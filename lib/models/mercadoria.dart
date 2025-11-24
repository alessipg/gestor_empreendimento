import 'package:receitacerta/models/produto.dart';
import 'package:receitacerta/config/medida.dart';

class Mercadoria extends Produto {
  final double venda;

  Mercadoria({
    super.id,
    required super.nome,
    required super.custo,
    required this.venda,
    required super.quantidade,
    required super.medida,
    required super.isDiscreto,
  });

  factory Mercadoria.fromMap(Map<String, dynamic> map) {
    return Mercadoria(
      id: map['id'],
      nome: map['nome'],
      custo: map['custo'].toDouble(),
      venda: map['venda'].toDouble(),
      quantidade: map['quantidade'].toDouble(),
      medida: Medida.fromString(map['medida']),
      isDiscreto: map['isDiscreto'] == 1,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'quantidade': quantidade,
    'custo': custo,
    'venda': venda,
    'medida': medida.sigla,
    'isDiscreto': isDiscreto ? 1 : 0,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'quantidade': quantidade,
    'custo': custo,
    'medida': medida.toString(), // ou medida.index
    'isDiscreto': isDiscreto,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Mercadoria && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
