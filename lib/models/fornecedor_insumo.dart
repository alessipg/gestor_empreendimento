class FornecedorInsumo {
  int? id;
  int fornecedorId;
  int insumoId;
  double preco;
  DateTime dataCadastro;

  FornecedorInsumo({
    this.id,
    required this.fornecedorId,
    required this.insumoId,
    required this.preco,
    DateTime? dataCadastro,
  }) : dataCadastro = dataCadastro ?? DateTime.now();

  factory FornecedorInsumo.fromMap(Map<String, dynamic> map) {
    return FornecedorInsumo(
      id: map['id'],
      fornecedorId: map['fornecedor_id'],
      insumoId: map['insumo_id'],
      preco: map['preco'].toDouble(),
      dataCadastro: DateTime.parse(map['data_cadastro']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'fornecedor_id': fornecedorId,
        'insumo_id': insumoId,
        'preco': preco,
        'data_cadastro': dataCadastro.toIso8601String(),
      };
}
