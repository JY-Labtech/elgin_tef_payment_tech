// ignore_for_file: constant_identifier_names
import 'package:check_licence_tech/check_licence_tech.dart';
import 'package:flutter/services.dart';
import 'package:elgin_payment_tech/licence/constants/licence_constants.dart';

final class ElginStyle {
  final MethodChannel channel;
  final String licenceKey;
  final CheckLicenceTech _licence = CheckLicenceTech.instance();

  // Cache da instância criada
  static ElginStyle? _instance;
  static bool _isLicenceValidated = false;

  ElginStyle._({
    required this.channel,
    required this.licenceKey,
  });

  /// Factory assíncrono com validação da licença
  static Future<ElginStyle> create({
    required MethodChannel channel,
    required String licenceKey,
  }) async {
    // Se já existe instância e licença validada, retorna ela diretamente
    if (_instance != null && _isLicenceValidated) {
      return _instance!;
    }

    final style = ElginStyle._(
      channel: channel,
      licenceKey: licenceKey,
    );

    _isLicenceValidated = await style._checkLicence();
    if (!_isLicenceValidated) {
      _instance = null; // Reseta a instância se a licença for inválida
      _isLicenceValidated = false; // Reseta o estado de licença válida
      throw Exception('Invalid licence key. Please check your licence key.');
    }
    _instance = style; // Armazena a instância criada
    _isLicenceValidated = true; // Marca a licença como válida

    return style;
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

  Future<bool> configureBackground({
    String? logoPath,
    String? backgroundColorHex,
    String? gradientStartHex,
    String? gradientEndHex,
  }) async {
    _ensureLicence();

    final params = <String, dynamic>{};
    if (logoPath != null) params['logoPath'] = logoPath;
    if (backgroundColorHex != null) params['backgroundColor'] = backgroundColorHex;
    if (gradientStartHex != null) params['gradientStart'] = gradientStartHex;
    if (gradientEndHex != null) params['gradientEnd'] = gradientEndHex;

    if (params.isEmpty) throw Exception("At least one parameter is required");
    if (gradientStartHex != null && gradientEndHex == null) {
      throw Exception("gradientEnd is required when gradientStart is informed");
    }
    if (gradientEndHex != null && gradientStartHex == null) {
      throw Exception("gradientStart is required when gradientEnd is informed");
    }

    try {
      await channel.invokeMethod("configureBackground", params);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> configureCustomHeader({
    String? buttonColorHex,
    String? iconColorHex,
    String? fontColorHex,
  }) async {
    _ensureLicence();

    final params = <String, dynamic>{};
    if (buttonColorHex != null) params['buttonColor'] = buttonColorHex;
    if (iconColorHex != null) params['iconColor'] = iconColorHex;
    if (fontColorHex != null) params['fontColor'] = fontColorHex;

    if (params.isEmpty) throw Exception("At least one parameter is required");

    try {
      await channel.invokeMethod("configureCustomHeader", params);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> configureIconsCenter({
    String? buttonColorHex,
    String? iconColorHex,
    String? fontColorHex,
    String? fontMessageColorHex,
  }) async {
    _ensureLicence();

    final params = <String, dynamic>{};
    if (buttonColorHex != null) params['buttonColor'] = buttonColorHex;
    if (iconColorHex != null) params['iconColor'] = iconColorHex;
    if (fontColorHex != null) params['fontColor'] = fontColorHex;
    if (fontMessageColorHex != null) params['fontMessageColor'] = fontMessageColorHex;

    if (params.isEmpty) throw Exception("At least one parameter is required");

    try {
      await channel.invokeMethod("configureIconsCenter", params);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearAllStyle() async {
    _ensureLicence();

    try {
      await channel.invokeMethod("clearAllStyle");
      return true;
    } catch (_) {
      return false;
    }
  }
}
