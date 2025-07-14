import 'package:check_licence_tech/check_licence_tech.dart';
import 'package:elgin_payment_tech/payments/payment.dart';

import 'licence/constants/licence_constants.dart';
import 'payments/style.dart';

export 'payments/model/elgin_response.dart';
export 'payments/model/elgin_transaction_response.dart';

class ElginPaymentTech {
  static final ElginPaymentTech _instance = ElginPaymentTech._internal();

  static ElginPaymentTech get instance => _instance;

  Payment? _payment;
  ElginStyle? _elginStyle;

  final _check = CheckLicenceTech.instance();

  ElginPaymentTech._internal();

  Future<String> getSerialNumber() async => await _check.getSerialNumber();

  Future<bool> _checkLicence({required String licenceKey}) async {
    if (licenceKey.isEmpty) return false;

    final licence = _check;
    final resultLicence = await licence.checkLicence(
      licenceKey,
      url: licenceCheck,
    );
    if (!resultLicence) {
      throw Exception('Invalid licence key. Please check your licence key.');
    }
    return resultLicence;
  }

  Future<Payment> initPayment({required String licenceKey}) async {
    if (_isPaymentInitialized) return _payment!;

    _payment = await Payment.create(channel: channel, licenceKey: licenceKey);
    return _payment!;
  }

  Future<ElginStyle> initStyle({required String licenceKey}) async {
    if (_isStyleInitialized) return _elginStyle!;

    _elginStyle = await ElginStyle.create(channel: channel, licenceKey: licenceKey);
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
