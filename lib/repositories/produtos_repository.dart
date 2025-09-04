import 'package:gestor_empreendimento/models/produto.dart';
import 'package:flutter/foundation.dart';

class ProdutosRepository extends ChangeNotifier {
  final List<Produto> _produtos = [];

  List<Produto> get produtos => _produtos;

  void addProduto(Produto produto) {
    _produtos.add(produto);
  }
}
