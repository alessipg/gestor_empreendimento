import 'package:flutter/foundation.dart';

class Produto extends ChangeNotifier {
  int id;
  String nome;
  double custo;

  Produto({required this.id, required this.nome, required this.custo});

  void addProduto() {
    // Lógica para adicionar o produto
    notifyListeners();
  }
}
