import 'package:receitacerta/models/produto.dart';
import 'package:receitacerta/config/medida.dart';

class Insumo extends Produto {
  Insumo({
    super.id,
    required super.nome,
    required super.custo,
    required super.quantidade,
    required super.medida,
    required super.isDiscreto,
  });

  factory Insumo.fromMap(Map<String, dynamic> map) {
    return Insumo(
      id: map['id'],
      nome: map['nome'],
      custo: map['custo'].toDouble(),
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
}
