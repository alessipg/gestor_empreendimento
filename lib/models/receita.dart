import 'package:gestor_empreendimento/models/insumo.dart';

class Receita {
  int id;
  String nome;
  List<Insumo> insumos = [];
  double valor;

  Receita({required this.id, required this.nome, required this.valor});

}
