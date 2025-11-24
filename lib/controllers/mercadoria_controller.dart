import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:receitacerta/config/medida.dart';
import 'package:receitacerta/controllers/receita_controller.dart';
import 'package:receitacerta/models/mercadoria.dart';
import 'package:receitacerta/repositories/mercadoria_repository.dart';
import 'dart:collection';

class MercadoriaController extends ChangeNotifier {
  final MercadoriaRepository repository;

  int _idCounter = 0;

  MercadoriaController(this.repository) {
    _initializeController();
  }

  _initializeController() async {
    await repository.waitForInitialization();
    // 🔹 Garante IDs únicos para mercadorias já existentes
    for (final mercadoria in repository.mercadorias) {
      if (mercadoria.id == null) {
        mercadoria.id = _idCounter++;
      } else if (mercadoria.id! >= _idCounter) {
        _idCounter = mercadoria.id! + 1;
      }
    }
    notifyListeners();
  }

  UnmodifiableListView<Mercadoria> get mercadorias =>
      UnmodifiableListView(repository.mercadorias);

  List<double> getCustos(String nome, ReceitaController receitaController) {
    final receitas = receitaController.receitas
        .where((r) => r.produto.nome == nome) // filtra
        .map((r) => r.custoUnitario) // pega apenas o custo
        .toList(); // transforma em lista

    if (receitas.isEmpty) {
      return [0.0];
    }

    return receitas;
  }

  double menorCusto(String nome, ReceitaController receitaController) {
    final custos = getCustos(nome, receitaController);
    if (custos.isEmpty) {
      return 0.0;
    }
    final menor = custos.reduce((a, b) => a < b ? a : b);
    return menor;
  }

  Future<void> criar(
    String nome,
    double venda,
    double quantidade,
    Medida medida,
    ReceitaController receitaController,
  ) async {
    if (repository.mercadorias.any(
      (element) =>
          element.nome.trim().toLowerCase() == nome.trim().toLowerCase(),
    )) {
      throw Exception('Mercadoria com nome $nome já existe.');
    }
    final menor = menorCusto(nome, receitaController);

    final mercadoria = Mercadoria(
      nome: nome,
      venda: venda,
      custo: menor,
      id: null,
      quantidade: quantidade,
      medida: medida,
      isDiscreto: false,
    );

    mercadoria.id = _idCounter++;
    // 🔹 ID vem só do controller
    await repository.addMercadoria(mercadoria);
  }

  List<Mercadoria> getAll() => List.unmodifiable(repository.mercadorias);

  Mercadoria getById(int id) {
    return repository.mercadorias.firstWhere(
      (mercadoria) => mercadoria.id == id,
    );
  }

  Future<void> update(Mercadoria mercadoria) async {
    final index = repository.mercadorias.indexWhere(
      (i) => i.id == mercadoria.id,
    );
    if (index == -1) {
      throw Exception('Mercadoria com id ${mercadoria.id} não encontrado.');
    }
    await repository.updateMercadoria(mercadoria);
  }

  Future<void> delete(int id) async {
    await repository.deleteMercadoria(id);
    notifyListeners();
  }

  List<Mercadoria> filtrarPorNome(String termo) {
    return mercadorias
        .where(
          (r) => removeDiacritics(
            r.nome.toLowerCase(),
          ).contains(removeDiacritics(termo.toLowerCase())),
        )
        .toList();
  }

  List<String> getNomesMercadorias() {
    return mercadorias.map((mercadoria) => mercadoria.nome).toList();
  }
}
