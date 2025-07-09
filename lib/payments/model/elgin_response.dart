import 'dart:convert';

import './elgin_transaction_response.dart';

class ElginResponse {
  final String? funcao;
  final String? mensagem;
  final ElginTransactionResponse? transaction;
  final int? resultCode;

  bool get isTransactionValid => transaction != null && transaction!.isTransactionValid;

  const ElginResponse({
    this.funcao,
    this.mensagem,
    this.transaction,
    this.resultCode,
  });

  ElginResponse copyWith({
    String? funcao,
    String? mensagem,
    ElginTransactionResponse? transaction,
    int? resultCode,
  }) {
    return ElginResponse(
      funcao: funcao ?? this.funcao,
      mensagem: mensagem ?? this.mensagem,
      transaction: transaction ?? this.transaction,
      resultCode: resultCode ?? this.resultCode,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'funcao': funcao,
      'mensagem': mensagem,
      'resultado': transaction?.toMap(),
      'resultCode': resultCode,
    };
  }

  factory ElginResponse.fromMap(Map<String, Object?> json) {
    return ElginResponse(
      funcao: json['funcao'] == null ? null : json['funcao'] as String,
      mensagem: json['mensagem'] == null ? null : json['mensagem'] as String,
      transaction: json['resultado'] == null
          ? null
          : (json['resultado'].toString()).contains('{')
              ? ElginTransactionResponse.fromJson(json['resultado'] as String)
              : null,
      resultCode: json['resultCode'] == null
          ? null
          : (json['resultCode'].toString()).contains('{')
              ? null
              : json['resultado'] as int,
    );
  }

  factory ElginResponse.fromJson(String value) {
    final decoded = json.decode(value);
    return ElginResponse.fromMap(decoded);
  }

  String toJson() {
    return json.encode(toMap());
  }

  @override
  String toString() {
    return '''ElginResponse(
                funcao:$funcao,
mensagem:$mensagem,
resultado:${transaction.toString()},
resultCode:$resultCode
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is ElginResponse && other.runtimeType == runtimeType && other.funcao == funcao && other.mensagem == mensagem && other.transaction == transaction;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, funcao, mensagem, transaction);
  }
}
