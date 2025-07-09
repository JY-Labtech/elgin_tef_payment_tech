import 'dart:convert';

class ElginTransactionResponse {
  final String? administradora;
  final String? autorizacao;
  final String? cnpjRede;
  final String? data;
  final String? mensagem;
  final String? nsu;
  final String? numeroCartao;
  final String? pagamento;
  final String? rede;
  final String? tipoCartao;
  final String? valor;
  final String? vencimento;
  final String? viaCliente;
  final String? viaEstabelecimento;
  final String? viaSMS;

  bool get isTransactionValid => nsu != null && nsu!.isNotEmpty;

  const ElginTransactionResponse({
    this.administradora,
    this.autorizacao,
    this.cnpjRede,
    this.data,
    this.mensagem,
    this.nsu,
    this.numeroCartao,
    this.pagamento,
    this.rede,
    this.tipoCartao,
    this.valor,
    this.vencimento,
    this.viaCliente,
    this.viaEstabelecimento,
    this.viaSMS,
  });

  ElginTransactionResponse copyWith({
    String? administradora,
    String? autorizacao,
    String? cnpjRede,
    String? data,
    String? mensagem,
    String? nsu,
    String? numeroCartao,
    String? pagamento,
    String? rede,
    String? tipoCartao,
    String? valor,
    String? vencimento,
    String? viaCliente,
    String? viaEstabelecimento,
    String? viaSMS,
  }) {
    return ElginTransactionResponse(
      administradora: administradora ?? this.administradora,
      autorizacao: autorizacao ?? this.autorizacao,
      cnpjRede: cnpjRede ?? this.cnpjRede,
      data: data ?? this.data,
      mensagem: mensagem ?? this.mensagem,
      nsu: nsu ?? this.nsu,
      numeroCartao: numeroCartao ?? this.numeroCartao,
      pagamento: pagamento ?? this.pagamento,
      rede: rede ?? this.rede,
      tipoCartao: tipoCartao ?? this.tipoCartao,
      valor: valor ?? this.valor,
      vencimento: vencimento ?? this.vencimento,
      viaCliente: viaCliente ?? this.viaCliente,
      viaEstabelecimento: viaEstabelecimento ?? this.viaEstabelecimento,
      viaSMS: viaSMS ?? this.viaSMS,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'administradora': administradora,
      'autorizacao': autorizacao,
      'cnpjRede': cnpjRede,
      'data': data,
      'mensagem': mensagem,
      'nsu': nsu,
      'numeroCartao': numeroCartao,
      'pagamento': pagamento,
      'rede': rede,
      'tipoCartao': tipoCartao,
      'valor': valor,
      'vencimento': vencimento,
      'viaCliente': viaCliente,
      'viaEstabelecimento': viaEstabelecimento,
      'viaSMS': viaSMS,
    };
  }

  factory ElginTransactionResponse.fromMap(Map<String, Object?> json) {
    return ElginTransactionResponse(
        administradora: json['administradora'] == null ? null : json['administradora'] as String,
        autorizacao: json['autorizacao'] == null ? null : json['autorizacao'] as String,
        cnpjRede: json['cnpjRede'] == null ? null : json['cnpjRede'] as String,
        data: json['data'] == null ? null : json['data'] as String,
        mensagem: json['mensagem'] == null ? null : json['mensagem'] as String,
        nsu: json['nsu'] == null ? null : json['nsu'] as String,
        numeroCartao: json['numeroCartao'] == null ? null : json['numeroCartao'] as String,
        pagamento: json['pagamento'] == null ? null : json['pagamento'] as String,
        rede: json['rede'] == null ? null : json['rede'] as String,
        tipoCartao: json['tipoCartao'] == null ? null : json['tipoCartao'] as String,
        valor: json['valor'] == null ? null : json['valor'] as String,
        vencimento: json['vencimento'] == null ? null : json['vencimento'] as String,
        viaCliente: json['viaCliente'] == null ? null : json['viaCliente'] as String,
        viaEstabelecimento: json['viaEstabelecimento'] == null ? null : json['viaEstabelecimento'] as String,
        viaSMS: json['viaSMS'] == null ? null : json['viaSMS'] as String);
  }

  factory ElginTransactionResponse.fromJson(String value) {
    final decoded = json.decode(value);
    return ElginTransactionResponse.fromMap(decoded);
  }

  String toJson() {
    return json.encode(toMap());
  }

  @override
  String toString() {
    return '''ElginTransactionResponse(
                administradora:$administradora,
autorizacao:$autorizacao,
cnpjRede:$cnpjRede,
data:$data,
mensagem:$mensagem,
nsu:$nsu,
numeroCartao:$numeroCartao,
pagamento:$pagamento,
rede:$rede,
tipoCartao:$tipoCartao,
valor:$valor,
vencimento:$vencimento,
viaCliente:$viaCliente,
viaEstabelecimento:$viaEstabelecimento,
viaSMS:$viaSMS
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is ElginTransactionResponse && other.runtimeType == runtimeType && other.administradora == administradora && other.autorizacao == autorizacao && other.cnpjRede == cnpjRede && other.data == data && other.mensagem == mensagem && other.nsu == nsu && other.numeroCartao == numeroCartao && other.pagamento == pagamento && other.rede == rede && other.tipoCartao == tipoCartao && other.valor == valor && other.vencimento == vencimento && other.viaCliente == viaCliente && other.viaEstabelecimento == viaEstabelecimento && other.viaSMS == viaSMS;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, administradora, autorizacao, cnpjRede, data, mensagem, nsu, numeroCartao, pagamento, rede, tipoCartao, valor, vencimento, viaCliente, viaEstabelecimento, viaSMS);
  }
}
