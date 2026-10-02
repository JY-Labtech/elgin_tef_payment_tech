import 'dart:async';
import 'dart:convert';

import 'package:elgin_payment_tech/elgin_payment_tech.dart';
import 'package:elgin_payment_tech/licence/constants/licence_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Simula o nativo: uma operação por vez; a segunda chamada concorrente recebe ELGIN_BUSY
/// e a primeira continua recebendo a sua própria resposta.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  void mockSingleOperationNative(Completer<Object?> idh) {
    var busy = false;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (busy) {
        throw PlatformException(code: 'ELGIN_BUSY', message: 'Já existe uma operação Elgin em andamento.');
      }
      busy = true;
      try {
        return await idh.future;
      } finally {
        busy = false;
      }
    });
  }

  test('segunda operação concorrente lança ELGIN_BUSY e a primeira recebe sua resposta', () async {
    final payment = ElginPaymentTech.I.initPayment();
    final idh = Completer<Object?>();
    mockSingleOperationNative(idh);

    final credit = payment.creditTransaction(value: '1000');
    await expectLater(
      payment.debitTransaction(value: '500'),
      throwsA(isA<PlatformException>().having((e) => e.code, 'code', 'ELGIN_BUSY')),
    );

    idh.complete(jsonEncode({'funcao': 'credito', 'mensagem': 'Transacao aprovada'}));
    final response = await credit;
    expect(response!.funcao, 'credito');
  });

  test('ElginStyle retorna false quando o canal está ocupado', () async {
    final style = ElginPaymentTech.I.initStyle();
    final idh = Completer<Object?>();
    mockSingleOperationNative(idh);

    final header = style.configureCustomHeader(buttonColorHex: '#000000');
    expect(await style.clearAllStyle(), isFalse);
    idh.complete(true);
    expect(await header, isTrue);
  });
}
