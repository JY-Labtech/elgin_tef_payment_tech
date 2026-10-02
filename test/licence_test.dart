import 'dart:convert';

import 'package:elgin_payment_tech/elgin_payment_tech.dart';
import 'package:elgin_payment_tech/licence/constants/licence_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <MethodCall>[];

  void mockNative(Object? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return handler(call);
    });
  }

  Never licenceError(MethodCall _) {
    throw PlatformException(code: 'LICENCE_ERROR', message: 'Licença vencida');
  }

  setUp(calls.clear);
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  group('licenceCheck', () {
    test('aponta para o servidor oficial da JY Labtech', () {
      final url = Uri.parse(utf8.decode(base64.decode(licenceCheck)));
      expect(url.scheme, 'https');
      expect(url.host, 'portal-api.jylabtech.com.br');
      expect(url.path, startsWith('/pos-payments/'));
      expect(url.toString(), 'https://portal-api.jylabtech.com.br/pos-payments/licence/check');
    });

    test('canal usado pelo plugin', () {
      expect(channel.name, 'elgin_payment_tech');
    });
  });

  group('Payment com licença inválida (LICENCE_ERROR)', () {
    final payment = ElginPaymentTech.I.initPayment();

    final operations = <String, Future<ElginResponse?> Function()>{
      'elginCredit': () => payment.creditTransaction(value: '1000'),
      'elginDebit': () => payment.debitTransaction(value: '1000'),
      'elginPix': () => payment.pixTransaction(value: '1000'),
      'elginCreditParc': () => payment.creditParcTransaction(value: '1000', parc: '2', financ: '1'),
      'refundElgin': () => payment.refoundTransaction(value: '1000', nsu: '123', date: '01/10/2026'),
      'reprinterElgin': payment.reprinterLastTransaction,
      'reportElgin': () => payment.report(nsu: '123', date: '01/10/2026'),
      'activeTerminalElgin': () => payment.activeTerminal(companyDocument: '00000000000000'),
      'configurePinpadElgin': () => payment.configurePinpad(appName: 'app', version: '1', textPinpad: 'oi'),
      'saleElgin': payment.sale,
    };

    operations.forEach((method, run) {
      test('$method lança PlatformException e nunca retorna sucesso', () async {
        mockNative(licenceError);
        await expectLater(
          run(),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', 'LICENCE_ERROR')
              .having((e) => e.message, 'message', 'Licença vencida')),
        );
        expect(calls.single.method, method);
      });
    });

    test('caminho de sucesso continua devolvendo ElginResponse', () async {
      mockNative((_) => jsonEncode({'funcao': 'credito', 'mensagem': 'Transacao aprovada'}));
      final response = await payment.creditTransaction(value: '1000');
      expect(response, isNotNull);
      expect(response!.funcao, 'credito');
      expect(response.mensagem, 'Transacao aprovada');
      expect(calls.single.arguments, {'value': '1000'});
    });
  });

  group('ElginStyle com licença inválida (LICENCE_ERROR)', () {
    final style = ElginPaymentTech.I.initStyle();

    test('todas as operações retornam false', () async {
      mockNative(licenceError);
      expect(await style.configureBackground(backgroundColorHex: '#FFFFFF'), isFalse);
      expect(await style.configureCustomHeader(buttonColorHex: '#000000'), isFalse);
      expect(await style.configureIconsCenter(iconColorHex: '#000000'), isFalse);
      expect(await style.clearAllStyle(), isFalse);
      expect(calls.map((c) => c.method), [
        'configureBackground',
        'configureCustomHeader',
        'configureIconsCenter',
        'clearAllStyle',
      ]);
    });

    test('com licença válida retornam true', () async {
      mockNative((_) => true);
      expect(await style.clearAllStyle(), isTrue);
    });
  });
}
