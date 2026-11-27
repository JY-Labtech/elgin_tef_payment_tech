import 'package:flutter/services.dart';

/// Nome do MethodChannel usado entre o Dart e o nativo Android.
// ignore: constant_identifier_names
const CHANNEL_NAME = "elgin_payment_tech";

/// MethodChannel do plugin.
const channel = MethodChannel(CHANNEL_NAME);
