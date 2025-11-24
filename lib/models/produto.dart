import 'package:flutter/foundation.dart';
import 'package:receitacerta/config/medida.dart';

class Produto extends ChangeNotifier {
  int? id;
  String nome;
  double custo;
  double quantidade;
  Medida medida;
  bool isDiscreto;

  Produto({
    this.id,
    required this.nome,
    required this.custo,
    required this.quantidade,
    required this.medida,
    required this.isDiscreto,
  });

  void addProduto() {
    // Lógica para adicionar o produto
    notifyListeners();
  }
}
