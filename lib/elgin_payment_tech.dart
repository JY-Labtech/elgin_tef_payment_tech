import 'package:elgin_payment_tech/licence/licence_service.dart';

import 'payments/payment.dart';
import 'payments/style.dart';

export 'payments/model/elgin_response.dart';
export 'payments/model/elgin_transaction_response.dart';

class ElginPaymentTech {
  // Instância única (singleton)
  static final ElginPaymentTech _instance = ElginPaymentTech._internal();

  // Getter público da instância
  static ElginPaymentTech get instance => _instance;

  Payment? _payment;
  ElginStyle? _elginStyle;

  // Construtor privado
  ElginPaymentTech._internal();

  /// Inicializa o pagamento (somente uma vez)
  Future<Payment> initPayment({required String licenceKey}) async {
    if (_isPaymentInitialized) {
      return _payment!;
    }
    try {
      final isValid = await LicenceService().checkLicence(licenceKey: licenceKey);
      if (!isValid) {
        throw Exception('Invalid licence key. Please check your licence key.');
      }

      _payment = Payment();
      return _payment!;
    } catch (e) {
      print('Error initializing payment: $e');
      rethrow;
    }
  }

  /// Inicializa o estilo (somente uma vez)
  Future<ElginStyle> initStyle({required String licenceKey}) async {
    if (_isStyleInitialized) {
      return _elginStyle!;
    }

    try {
      final isValid = await LicenceService().checkLicence(licenceKey: licenceKey);
      if (!isValid) {
        throw Exception('Invalid licence key. Please check your licence key.');
      }

      _elginStyle = ElginStyle();
      return _elginStyle!;
    } catch (e) {
      print('Error initializing elginStyle: $e');
      rethrow;
    }
  }

  Payment get payment {
    if (!_isPaymentInitialized) {
      throw Exception('Payment not initialized. Call initPayment() first.');
    }
    return _payment!;
  }

  ElginStyle get style {
    if (!_isStyleInitialized) {
      throw Exception('ElginStyle not initialized. Call initStyle() first.');
    }
    return _elginStyle!;
  }

  bool get _isPaymentInitialized => _payment != null;
  bool get _isStyleInitialized => _elginStyle != null;
}
