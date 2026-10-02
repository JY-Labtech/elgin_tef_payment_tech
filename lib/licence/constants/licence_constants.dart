import 'package:flutter/services.dart';

/// URL oficial de validação de licença (Base64 de
/// `https://licence-server.invalid/pos-payments/licence/check`).
///
/// A validação é feita no Android, que sempre usa o servidor oficial da JY Labtech:
/// um `licenceInternalKey` (local.properties) fora desse servidor é ignorado.
const String licenceCheck = '***REMOVIDO***';

// ignore: constant_identifier_names
const CHANNEL_NAME = "elgin_payment_tech";

const channel = MethodChannel(CHANNEL_NAME);
