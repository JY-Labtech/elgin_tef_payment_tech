import 'dart:convert';

import 'package:elgin_payment_tech/elgin_payment_tech.dart';
import 'package:elgin_payment_tech/payments/utils/channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cada método público chama o MethodChannel direto, com o nome e os argumentos esperados
/// pelo nativo (android/.../core/ElginPaymentTech.java).
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

  final approved = jsonEncode({
    'funcao': 'credito',
    'mensagem': 'Transacao aprovada',
    'resultado': jsonEncode({'nsu': '123456', 'valor': '1000', 'viaCliente': 'VIA CLIENTE'}),
  });

  setUp(calls.clear);
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('canal usado pelo plugin', () {
    expect(channel.name, 'elgin_payment_tech');
  });

  group('Payment', () {
    final payment = ElginPaymentTech.I.initPayment();

    test('initPayment devolve sempre a mesma instância', () {
      expect(identical(ElginPaymentTech.I.initPayment(), payment), isTrue);
      expect(identical(ElginPaymentTech.I.payment, payment), isTrue);
    });

    final operations = <String, (Future<ElginResponse?> Function(), Object?)>{
      'elginCredit': (() => payment.creditTransaction(value: '1000'), {'value': '1000'}),
      'elginDebit': (() => payment.debitTransaction(value: '1000'), {'value': '1000'}),
      'elginPix': (() => payment.pixTransaction(value: '1000'), {'value': '1000'}),
      'elginCreditParc': (
        () => payment.creditParcTransaction(value: '1000', parc: '2', financ: '1'),
        {'value': '1000', 'parc': '2', 'financ': '1'},
      ),
      'refundElgin': (
        () => payment.refoundTransaction(value: '1000', nsu: '123', date: '01/10/2026'),
        {'value': '1000', 'nsu': '123', 'date': '01/10/2026'},
      ),
      'reprinterElgin': (payment.reprinterLastTransaction, null),
      'reportElgin': (() => payment.report(nsu: '123', date: '01/10/2026'), {'nsu': '123', 'date': '01/10/2026'}),
      'activeTerminalElgin': (
        () => payment.activeTerminal(companyDocument: '00000000000000'),
        {'companyDocument': '00000000000000'},
      ),
      'configurePinpadElgin': (
        () => payment.configurePinpad(appName: 'app', version: '1', textPinpad: 'oi'),
        {'name': 'app', 'version': '1', 'textPinpad': 'oi'},
      ),
      'saleElgin': (payment.sale, null),
    };

    operations.forEach((method, op) {
      final (run, args) = op;

      test('$method chama o canal e devolve ElginResponse', () async {
        mockNative((_) => approved);
        final response = await run();
        expect(calls.single.method, method);
        expect(calls.single.arguments, args);
        expect(response, isNotNull);
        expect(response!.funcao, 'credito');
        expect(response.mensagem, 'Transacao aprovada');
        expect(response.transaction?.nsu, '123456');
        expect(response.isTransactionValid, isTrue);
      });

      test('$method repassa PlatformException do nativo (ELGIN_ERROR)', () async {
        mockNative((_) => throw PlatformException(code: 'ELGIN_ERROR', message: 'Operação cancelada'));
        await expectLater(
          run(),
          throwsA(isA<PlatformException>()
              .having((e) => e.code, 'code', 'ELGIN_ERROR')
              .having((e) => e.message, 'message', 'Operação cancelada')),
        );
        expect(calls.single.method, method);
      });
    });
  });

  group('ElginStyle', () {
    final style = ElginPaymentTech.I.initStyle();

    test('cada método chama o canal com os parâmetros informados e retorna true', () async {
      mockNative((_) => true);
      expect(
        await style.configureBackground(logoPath: '/sdcard/logo.png', gradientStartHex: '#000000', gradientEndHex: '#FFFFFF'),
        isTrue,
      );
      expect(await style.configureCustomHeader(buttonColorHex: '#000000', fontColorHex: '#FFFFFF'), isTrue);
      expect(await style.configureIconsCenter(iconColorHex: '#000000', fontMessageColorHex: '#111111'), isTrue);
      expect(await style.clearAllStyle(), isTrue);

      expect(calls.map((c) => c.method), [
        'configureBackground',
        'configureCustomHeader',
        'configureIconsCenter',
        'clearAllStyle',
      ]);
      expect(calls[0].arguments, {'logoPath': '/sdcard/logo.png', 'gradientStart': '#000000', 'gradientEnd': '#FFFFFF'});
      expect(calls[1].arguments, {'buttonColor': '#000000', 'fontColor': '#FFFFFF'});
      expect(calls[2].arguments, {'iconColor': '#000000', 'fontMessageColor': '#111111'});
      expect(calls[3].arguments, isNull);
    });

    test('erro do nativo vira false', () async {
      mockNative((_) => throw PlatformException(code: 'ELGIN_ERROR'));
      expect(await style.configureBackground(backgroundColorHex: '#FFFFFF'), isFalse);
      expect(await style.configureCustomHeader(buttonColorHex: '#000000'), isFalse);
      expect(await style.configureIconsCenter(iconColorHex: '#000000'), isFalse);
      expect(await style.clearAllStyle(), isFalse);
      expect(calls, hasLength(4));
    });

    test('valida os parâmetros antes de chamar o canal', () async {
      mockNative((_) => true);
      expect(() => style.configureBackground(), throwsException);
      expect(() => style.configureBackground(gradientStartHex: '#000000'), throwsException);
      expect(() => style.configureBackground(gradientEndHex: '#000000'), throwsException);
      expect(() => style.configureCustomHeader(), throwsException);
      expect(() => style.configureIconsCenter(), throwsException);
      expect(calls, isEmpty);
    });
  });
}
