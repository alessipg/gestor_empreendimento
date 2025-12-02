class Fornecedor {
  int? id;
  String nome;
  String? cnpj;
  String? telefone;
  String? email;
  String? cep;
  String? endereco;
  String? bairro;
  String? cidade;
  String? estado;

  Fornecedor({
    this.id,
    required this.nome,
    this.cnpj,
    this.telefone,
    this.email,
    this.cep,
    this.endereco,
    this.bairro,
    this.cidade,
    this.estado,
  });

  factory Fornecedor.fromMap(Map<String, dynamic> map) {
    return Fornecedor(
      id: map['id'],
      nome: map['nome'],
      cnpj: map['cnpj'],
      telefone: map['telefone'],
      email: map['email'],
      cep: map['cep'],
      endereco: map['endereco'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      estado: map['estado'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'cnpj': cnpj,
        'telefone': telefone,
        'email': email,
        'cep': cep,
        'endereco': endereco,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
      };

  Map<String, dynamic> toJson() => toMap();
}
