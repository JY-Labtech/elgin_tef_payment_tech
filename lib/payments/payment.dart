// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/services.dart';
import 'utils/payment_types.dart';
import 'model/elgin_response.dart';

//Fixed channel name
// ignore: constant_identifier_names
const CHANNEL_NAME = "elgin_payment_tech";

class Payment {
  final channel = const MethodChannel(CHANNEL_NAME);

  Future<ElginResponse?> configurePinpad({
    required String appName,
    required String version,
    required String textPinpad,
  }) async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.CONFIGURE_PINPAD.method,
        {
          'name': appName,
          'version': version,
          'textPinpad': textPinpad,
        },
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> activeTerminal({
    required String companyDocument,
  }) async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.ACTIVE_TERMINAL.method,
        {
          'companyDocument': companyDocument,
        },
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> creditTransaction({
    required String value,
  }) async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.CREDIT.method,
        {
          'value': value,
        },
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> debitTransaction({
    required String value,
  }) async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.DEBIT.method,
        {
          'value': value,
        },
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> pixTransaction({
    required String value,
  }) async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.PIX.method,
        {
          'value': value,
        },
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> creditParcTransaction({
    required String value,
    required String parc,
    required String financ,
  }) async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.CREDIT_PARC.method,
        {
          'value': value,
          'parc': parc,
          'financ': financ,
        },
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> refoundTransaction({
    required String value,
    required String nsu,
    required String date,
  }) async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.REFOUND.method,
        {
          'value': value,
          'nsu': nsu,
          'date': date,
        },
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> reprinterLastTransaction() async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.REPRINTER.method,
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> report({
    required String nsu,
    required String date,
  }) async {
    try {
      final response = await channel.invokeMethod(
        PaymentTypeCall.REPORT.method,
      );

      final model = ElginResponse.fromJson(response.toString());

      return model;
    } catch (_) {
      return null;
    }
  }

  Future<ElginResponse?> sale() async {
    try {
      final responseFlutter = await channel.invokeMethod(
        PaymentTypeCall.SALE.method,
      );

      final response = ElginResponse.fromJson(responseFlutter.toString());
      return response;
    } catch (e) {
      return null;
    }
  }
}
