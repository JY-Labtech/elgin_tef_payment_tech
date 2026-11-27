import 'dart:convert';

import 'package:elgin_payment_tech/elgin_payment_tech.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ElginResponse.resultCode', () {
    test('lê a chave resultCode (int)', () {
      final r = ElginResponse.fromJson(jsonEncode({
        'funcao': 'credito',
        'resultado': jsonEncode({'nsu': '1'}),
        'resultCode': -1,
      }));
      expect(r.resultCode, -1);
      expect(r.transaction?.nsu, '1');
    });

    test('aceita resultCode como texto numérico', () {
      expect(ElginResponse.fromMap({'resultCode': '0'}).resultCode, 0);
    });

    test('não confunde resultCode com resultado', () {
      // Antes lia json['resultado'] e quebrava com TypeError.
      final r = ElginResponse.fromMap({'resultado': jsonEncode({'nsu': '9'}), 'resultCode': 5});
      expect(r.resultCode, 5);
      expect(r.transaction?.nsu, '9');
    });

    test('ausente ou inválido vira null', () {
      expect(ElginResponse.fromMap({'funcao': 'pix'}).resultCode, isNull);
      expect(ElginResponse.fromMap({'resultCode': '{x}'}).resultCode, isNull);
    });

    test('toJson/fromJson preservam resultCode', () {
      const original = ElginResponse(
        funcao: 'debito',
        mensagem: 'ok',
        resultCode: 3,
        transaction: ElginTransactionResponse(nsu: '42'),
      );
      final copy = ElginResponse.fromJson(original.toJson());
      expect(copy.resultCode, 3);
      expect(copy.transaction?.nsu, '42');
    });
  });
}
