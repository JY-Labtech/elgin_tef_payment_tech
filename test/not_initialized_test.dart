import 'package:elgin_payment_tech/elgin_payment_tech.dart';
import 'package:flutter_test/flutter_test.dart';

// Arquivo separado: o estado de ElginPaymentTech.I é global por isolate.
void main() {
  test('payment antes de initPayment lança exceção', () {
    expect(() => ElginPaymentTech.I.payment, throwsException);
  });

  test('style antes de initStyle lança exceção', () {
    expect(() => ElginPaymentTech.I.style, throwsException);
  });
}
