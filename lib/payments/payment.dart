// ignore_for_file: constant_identifier_names
import 'package:elgin_payment_tech/payments/model/elgin_response.dart';
import 'package:elgin_payment_tech/payments/utils/payment_types.dart';
import 'package:flutter/services.dart';

final class Payment {
  final MethodChannel channel;

  // Cache da instância criada
  static Payment? _instance;

  Payment._({
    required this.channel,
  });

  /// Cria (uma única vez) a instância que conversa com o Elgin IDH pelo [channel].
  static Payment create({
    required MethodChannel channel,
  }) {
    // Se já existe instância, retorna ela diretamente
    if (_instance != null) {
      return _instance!;
    }

    final payment = Payment._(
      channel: channel,
    );

    _instance = payment; // Armazena a instância criada
    return payment;
  }

  // MÉTODOS DE OPERAÇÕES

  Future<ElginResponse?> configurePinpad({
    required String appName,
    required String version,
    required String textPinpad,
  }) async {
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
    final response = await channel.invokeMethod(
      PaymentTypeCall.ACTIVE_TERMINAL.method,
      {'companyDocument': companyDocument},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> creditTransaction({required String value}) async {
    final response = await channel.invokeMethod(
      PaymentTypeCall.CREDIT.method,
      {'value': value},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> debitTransaction({required String value}) async {
    final response = await channel.invokeMethod(
      PaymentTypeCall.DEBIT.method,
      {'value': value},
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> pixTransaction({required String value}) async {
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
    final response = await channel.invokeMethod(
      PaymentTypeCall.REPRINTER.method,
    );
    return ElginResponse.fromJson(response.toString());
  }

  Future<ElginResponse?> report({
    required String nsu,
    required String date,
  }) async {
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
    final response = await channel.invokeMethod(
      PaymentTypeCall.SALE.method,
    );
    return ElginResponse.fromJson(response.toString());
  }
}
