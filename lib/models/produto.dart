import 'package:flutter/foundation.dart';

class Produto extends ChangeNotifier {
  int id;
  String nome;
  double custo;
  int quantidade;

  Produto({required this.id, required this.nome, required this.custo, required this.quantidade});

  void addProduto() {
    // Lógica para adicionar o produto
    notifyListeners();
  }
}
