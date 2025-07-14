import 'package:check_licence_tech/check_licence_tech.dart';

import 'licence/constants/licence_constants.dart';
import 'payments/model/elgin_response.dart';
import 'payments/style.dart';
import 'payments/utils/payment_types.dart';

export 'payments/model/elgin_response.dart';
export 'payments/model/elgin_transaction_response.dart';

class ElginPaymentTech {
  static final ElginPaymentTech _instance = ElginPaymentTech._internal();

  static ElginPaymentTech get instance => _instance;

  _Payment? _payment;
  ElginStyle? _elginStyle;

  final _check = CheckLicenceTech();

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

  Future<_Payment> initPayment({required String licenceKey}) async {
    if (_isPaymentInitialized) return _payment!;
    final isValid = await _checkLicence(licenceKey: licenceKey);
    if (!isValid) throw Exception('Invalid licence key.');
    _payment = _Payment(isValid);
    return _payment!;
  }

  Future<ElginStyle> initStyle({required String licenceKey}) async {
    if (_isStyleInitialized) return _elginStyle!;
    final isValid = await _checkLicence(licenceKey: licenceKey);
    if (!isValid) throw Exception('Invalid licence key.');
    _elginStyle = ElginStyle();
    return _elginStyle!;
  }

  _Payment get payment {
    if (_payment == null || !_payment!._isValidLicence) {
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

class _Payment {
  final bool _isValidLicence;

  _Payment(this._isValidLicence);

  void _ensureValid() {
    if (!_isValidLicence) {
      throw Exception('Licença inválida. Acesso bloqueado.');
    }
  }

  Future<ElginResponse?> configurePinpad({
    required String appName,
    required String version,
    required String textPinpad,
  }) async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.CONFIGURE_PINPAD.method,
      {
        'name': appName,
        'version': version,
        'textPinpad': textPinpad,
      },
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> activeTerminal({
    required String companyDocument,
  }) async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.ACTIVE_TERMINAL.method,
      {
        'companyDocument': companyDocument,
      },
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> creditTransaction({required String value}) async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.CREDIT.method,
      {'value': value},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> debitTransaction({required String value}) async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.DEBIT.method,
      {'value': value},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> pixTransaction({required String value}) async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.PIX.method,
      {'value': value},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> creditParcTransaction({
    required String value,
    required String parc,
    required String financ,
  }) async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.CREDIT_PARC.method,
      {
        'value': value,
        'parc': parc,
        'financ': financ,
      },
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> refoundTransaction({
    required String value,
    required String nsu,
    required String date,
  }) async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.REFOUND.method,
      {
        'value': value,
        'nsu': nsu,
        'date': date,
      },
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> reprinterLastTransaction() async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.REPRINTER.method,
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> report({
    required String nsu,
    required String date,
  }) async {
    _ensureValid();
    final response = await channel.invokeMethod(
      PaymentTypeCall.REPORT.method,
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> sale() async {
    _ensureValid();
    final responseFlutter = await channel.invokeMethod(
      PaymentTypeCall.SALE.method,
    );
    return ElginResponse.fromJson(responseFlutter.toString());
  }
}
