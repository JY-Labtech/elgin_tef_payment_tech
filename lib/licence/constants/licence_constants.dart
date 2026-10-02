import 'package:flutter/services.dart';

/// URL oficial de validação de licença (Base64 de
/// `https://portal-api.jylabtech.com.br/pos-payments/licence/check`).
///
/// A validação é feita no Android, que sempre usa o servidor oficial da JY Labtech:
/// um `licenceInternalKey` (local.properties) fora desse servidor é ignorado.
const String licenceCheck = 'aHR0cHM6Ly9wb3J0YWwtYXBpLmp5bGFidGVjaC5jb20uYnIvcG9zLXBheW1lbnRzL2xpY2VuY2UvY2hlY2s=';

// ignore: constant_identifier_names
const CHANNEL_NAME = "elgin_payment_tech";

const channel = MethodChannel(CHANNEL_NAME);
