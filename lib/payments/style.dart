// ignore_for_file: constant_identifier_names
import 'package:flutter/services.dart';

final class ElginStyle {
  final MethodChannel channel;

  // Cache da instância criada
  static ElginStyle? _instance;

  ElginStyle._({
    required this.channel,
  });

  /// Cria (uma única vez) a instância de personalização visual do Elgin IDH.
  static ElginStyle create({
    required MethodChannel channel,
  }) {
    // Se já existe instância, retorna ela diretamente
    if (_instance != null) {
      return _instance!;
    }

    final style = ElginStyle._(
      channel: channel,
    );

    _instance = style; // Armazena a instância criada

    return style;
  }

  Future<bool> configureBackground({
    String? logoPath,
    String? backgroundColorHex,
    String? gradientStartHex,
    String? gradientEndHex,
  }) async {
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
    try {
      await channel.invokeMethod("clearAllStyle");
      return true;
    } catch (_) {
      return false;
    }
  }
}
