import 'package:gestor_empreendimento/models/insumo.dart';

class Receita {
  int id;
  String nome;
  double valor;
  Map<Insumo, double> consumoPorUnidade; // chave: insumo, valor: quantidade por unidade

  Receita({required this.id, required this.nome, required this.valor, required this.consumoPorUnidade});

}
