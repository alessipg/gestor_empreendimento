import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:receitacerta/repositories/insumo_repository.dart';
import 'package:diacritic/diacritic.dart';

class InsumoController extends ChangeNotifier {
  final InsumoRepository repository;
  int _idCounter = 0;

  InsumoController(this.repository) {
    _initializeController();
  }

  Future<void> _initializeController() async {
    await repository.waitForInitialization();
    // 🔹 Garante que todos os insumos já tenham ID
    for (final insumo in repository.insumos) {
      if (insumo.id == null) {
        insumo.id = _idCounter++;
      } else if (insumo.id! >= _idCounter) {
        _idCounter = insumo.id! + 1;
      }
    }
    notifyListeners();
  }

  UnmodifiableListView<Insumo> get insumos =>
      UnmodifiableListView(repository.insumos);

  Future<void> criar(Insumo insumo) async {
    if (repository.insumos.any((element) => element.nome == insumo.nome)) {
      throw Exception('Insumo com nome ${insumo.nome} já existe.');
    }
    insumo.id = _idCounter++; // 🔹 id atribuído aqui
    await repository.addInsumo(insumo);
    notifyListeners();
  }

  Future<void> inserirEstoque(int id, double quantidade, double valor) async {
    final insumo = repository.insumos.firstWhere((insumo) => insumo.id == id);
    // custo médio ponderado
    insumo.custo =
        ((insumo.custo * insumo.quantidade) + (valor * quantidade)) /
        (insumo.quantidade + quantidade);
    insumo.quantidade += quantidade;

    await repository.updateInsumo(insumo);
    notifyListeners();
  }

  Future<void> extrairEstoque(int id, double quantidade) async {
    final insumo = repository.insumos.firstWhere((insumo) => insumo.id == id);
    if (insumo.quantidade < quantidade) {
      throw Exception('Quantidade insuficiente de ${insumo.nome} em estoque.');
    }
    insumo.quantidade -= quantidade;

    await repository.updateInsumo(insumo);
    notifyListeners();
  }

  Future<void> update(Insumo insumo) async {
    final index = repository.insumos.indexWhere((i) => i.id == insumo.id);
    if (index == -1) {
      throw Exception('Insumo com id ${insumo.id} não encontrado.');
    }
    await repository.updateInsumo(insumo);
    notifyListeners();
  }

  List<Insumo> getAll() => List.unmodifiable(repository.insumos);

  Insumo getById(int id) {
    return repository.insumos.firstWhere((insumo) => insumo.id == id);
  }

  bool checkQuantidade(int id, double quantidade) {
    final insumo = repository.insumos.firstWhere((insumo) => insumo.id == id);
    return insumo.quantidade >= quantidade;
  }

  Future<void> delete(int id) async {
    await repository.deleteInsumo(id);
    notifyListeners();
  }

  List<Insumo> filtrarPorNome(String termo) {
    return insumos
        .where(
          (r) => removeDiacritics(
            r.nome.toLowerCase(),
          ).contains(removeDiacritics(termo.toLowerCase())),
        )
        .toList();
  }

  List<String> getNomesInsumos() {
    return insumos.map((insumo) => insumo.nome).toList();
  }
}
