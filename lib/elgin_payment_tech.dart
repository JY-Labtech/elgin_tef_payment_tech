import 'package:check_licence_tech/check_licence_tech.dart';
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

  final _check = CheckLicenceTech.instance();

  ElginPaymentTech._internal();

  Future<String> getSerialNumber() async => await _check.getSerialNumber();

  Future<bool> wipeLicenceCache() async => await _check.wipeLicence();

  Future<Payment> initPayment({required String licenceKey}) async {
    if (_isPaymentInitialized) return _payment!;

    _payment = await Payment.create(channel: channel, licenceKey: licenceKey);
    return _payment!;
  }

  Future<ElginStyle> initStyle({required String licenceKey}) async {
    if (_isStyleInitialized) return _elginStyle!;

    _elginStyle = await ElginStyle.create(
      channel: channel,
      licenceKey: licenceKey,
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
