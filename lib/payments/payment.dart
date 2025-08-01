// ignore_for_file: constant_identifier_names
import 'package:check_licence_tech/check_licence_tech.dart';
import 'package:flutter/services.dart';
import 'package:elgin_payment_tech/licence/constants/licence_constants.dart';
import 'package:elgin_payment_tech/payments/model/elgin_response.dart';
import 'package:elgin_payment_tech/payments/utils/payment_types.dart';

final class Payment {
  final MethodChannel channel;
  final String licenceKey;
  final CheckLicenceTech _licence = CheckLicenceTech.instance();

  // Cache da instância criada
  static Payment? _instance;
  static bool _isLicenceValidated = false;

  Payment._({
    required this.channel,
    required this.licenceKey,
  });

  /// Factory assíncrono com verificação de licença
  static Future<Payment> create({
    required MethodChannel channel,
    required String licenceKey,
  }) async {
    // Se já existe instância e licença validada, retorna ela diretamente
    if (_instance != null && _isLicenceValidated) {
      return _instance!;
    }

    final payment = Payment._(
      channel: channel,
      licenceKey: licenceKey,
    );

    _isLicenceValidated = await payment._checkLicence();
    if (!_isLicenceValidated) {
      _instance = null; // Reseta a instância se a licença for inválida
      _isLicenceValidated = false; // Reseta o estado de licença válida
      throw Exception('Invalid licence key. Please check your licence key.');
    }

    _instance = payment; // Armazena a instância criada
    _isLicenceValidated = true;
    return payment;
  }

  Future<bool> _checkLicence() async {
    if (licenceKey.isEmpty) return false;
    return await _licence.checkLicence(
      licenceKey,
      url: licenceCheck,
    );
  }

  void _ensureLicence() {
    if (!_isLicenceValidated) {
      throw Exception('Invalid licence key. Please check your licence key.');
    }
  }

  // MÉTODOS DE OPERAÇÕES

  Future<ElginResponse?> configurePinpad({
    required String appName,
    required String version,
    required String textPinpad,
  }) async {
    _ensureLicence();
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
    _ensureLicence();
    final response = await channel.invokeMethod(
      PaymentTypeCall.ACTIVE_TERMINAL.method,
      {'companyDocument': companyDocument},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> creditTransaction({required String value}) async {
    _ensureLicence();
    final response = await channel.invokeMethod(
      PaymentTypeCall.CREDIT.method,
      {'value': value},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> debitTransaction({required String value}) async {
    _ensureLicence();
    final response = await channel.invokeMethod(
      PaymentTypeCall.DEBIT.method,
      {'value': value},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> pixTransaction({required String value}) async {
    _ensureLicence();
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
    _ensureLicence();
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
    _ensureLicence();
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
    _ensureLicence();
    final response = await channel.invokeMethod(
      PaymentTypeCall.REPRINTER.method,
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> report({
    required String nsu,
    required String date,
  }) async {
    _ensureLicence();
    final response = await channel.invokeMethod(
      PaymentTypeCall.REPORT.method,
      {
        'nsu': nsu,
        'date': date,
      },
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> sale() async {
    _ensureLicence();
    final response = await channel.invokeMethod(
      PaymentTypeCall.SALE.method,
    );
    return ElginResponse.fromJson(response.toString());
  }
}
