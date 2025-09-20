import 'package:elgin_payment_tech/payments/payment.dart';

import 'licence/constants/licence_constants.dart';
import 'payments/style.dart';

export 'payments/model/elgin_response.dart';
export 'payments/model/elgin_transaction_response.dart';

final class ElginPaymentTech {
  static ElginPaymentTech? _instance;

  static ElginPaymentTech get I {
    _instance ??= ElginPaymentTech._internal();
    return _instance!;
  }

  Payment? _payment;
  ElginStyle? _elginStyle;

  ElginPaymentTech._internal();

  Payment initPayment() {
    if (_isPaymentInitialized) return _payment!;

    _payment = Payment.create(channel: channel);
    return _payment!;
  }

  ElginStyle initStyle() {
    if (_isStyleInitialized) return _elginStyle!;

    _elginStyle = ElginStyle.create(
      channel: channel,
    );
    return _elginStyle!;
  }

  Payment get payment {
    if (_payment == null) {
      throw Exception('Payment não autorizado. Licença inválida.');
    }
    return _payment!;
  }

  ElginStyle get style {
    if (!_isStyleInitialized) throw Exception('ElginStyle não inicializado.');
    return _elginStyle!;
  }

  bool get _isPaymentInitialized => _payment != null;
  bool get _isStyleInitialized => _elginStyle != null;
}
