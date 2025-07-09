import 'package:flutter/services.dart';

// ignore: constant_identifier_names
const CHANNEL_NAME = "elgin_payment_tech";

class ElginStyle {
  final channel = const MethodChannel(CHANNEL_NAME);

  Future<dynamic> configureBackground({
    String? logoPath,
    String? backgroundColorHex,
    String? gradientStartHex,
    String? gradientEndHex,
  }) async {
    Map<String, dynamic> params = {};
    if (logoPath != null) params['logoPath'] = logoPath;
    if (backgroundColorHex != null) params['backgroundColor'] = backgroundColorHex;
    if (gradientStartHex != null) params['gradientStart'] = gradientStartHex;
    if (gradientEndHex != null) params['gradientEnd'] = gradientEndHex;

    if (params.isEmpty) {
      throw Exception("At least one parameter is required");
    }

    if (gradientStartHex != null && gradientEndHex == null) {
      throw Exception("gradientEnd is required when gradientStart is informed");
    }

    if (gradientEndHex != null && gradientStartHex == null) {
      throw Exception("gradientStart is required when gradientEnd is informed");
    }

    try {
      channel.invokeMethod(
        "configureBackground",
        params,
      );

      return true;
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> configureCustomHeader({
    String? buttonColorHex,
    String? iconColorHex,
    String? fontColorHex,
  }) async {
    Map<String, dynamic> params = {};
    if (buttonColorHex != null) params['buttonColor'] = buttonColorHex;
    if (iconColorHex != null) params['iconColor'] = iconColorHex;
    if (fontColorHex != null) params['fontColor'] = fontColorHex;

    if (params.isEmpty) {
      throw Exception("At least one parameter is required");
    }

    try {
      channel.invokeMethod(
        "configureCustomHeader",
        params,
      );

      return true;
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> configureIconsCenter({
    String? buttonColorHex,
    String? iconColorHex,
    String? fontColorHex,
    String? fontMessageColorHex,
  }) async {
    Map<String, dynamic> params = {};
    if (buttonColorHex != null) params['buttonColor'] = buttonColorHex;
    if (iconColorHex != null) params['iconColor'] = iconColorHex;
    if (fontColorHex != null) params['fontColor'] = fontColorHex;
    if (fontMessageColorHex != null) params['fontMessageColor'] = fontMessageColorHex;

    if (params.isEmpty) {
      throw Exception("At least one parameter is required");
    }

    try {
      channel.invokeMethod(
        "configureIconsCenter",
        params,
      );

      return true;
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> clearAllStyle() async {
    try {
      channel.invokeMethod(
        "clearAllStyle",
      );

      return true;
    } catch (_) {
      return null;
    }
  }
}
