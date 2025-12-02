import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:receitacerta/models/fornecedor.dart';
import 'package:receitacerta/repositories/fornecedor_repository.dart';
import 'package:diacritic/diacritic.dart';

class FornecedorController extends ChangeNotifier {
  final FornecedorRepository repository;
  int _idCounter = 0;

  FornecedorController(this.repository) {
    _initializeController();
  }

  Future<void> _initializeController() async {
    await repository.waitForInitialization();
    for (final fornecedor in repository.fornecedores) {
      if (fornecedor.id == null) {
        fornecedor.id = _idCounter++;
      } else if (fornecedor.id! >= _idCounter) {
        _idCounter = fornecedor.id! + 1;
      }
    }
    notifyListeners();
  }

  UnmodifiableListView<Fornecedor> get fornecedores =>
      UnmodifiableListView(repository.fornecedores);

  UnmodifiableListView<Fornecedor> getAll() {
    return UnmodifiableListView(repository.fornecedores);
  }

  Future<void> criar(Fornecedor fornecedor) async {
    await repository.addFornecedor(fornecedor);
    notifyListeners();
  }

  Future<void> atualizar(Fornecedor fornecedor) async {
    await repository.updateFornecedor(fornecedor);
    notifyListeners();
  }

  Future<void> deletar(int id) async {
    await repository.deleteFornecedor(id);
    notifyListeners();
  }

  List<Fornecedor> filtrarPorNome(String nome) {
    if (nome.isEmpty) return repository.fornecedores;

    final nomeNormalizado = removeDiacritics(nome.toLowerCase());

    return repository.fornecedores.where((fornecedor) {
      final fornecedorNomeNormalizado = removeDiacritics(
        fornecedor.nome.toLowerCase(),
      );
      return fornecedorNomeNormalizado.contains(nomeNormalizado);
    }).toList();
  }

  Future<void> addInsumoPrice(
    int fornecedorId,
    int insumoId,
    double preco,
  ) async {
    await repository.addInsumoPrice(fornecedorId, insumoId, preco);
    notifyListeners();
  }

  Future<void> updateInsumoPrice(int precoId, double preco) async {
    await repository.updateInsumoPrice(precoId, preco);
    notifyListeners();
  }

  Future<void> removeInsumoPrice(int precoId) async {
    await repository.removeInsumoPrice(precoId);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getFornecedoresComPrecoByInsumo(
    int insumoId,
  ) async {
    return await repository.getFornecedoresComPrecoByInsumo(insumoId);
  }

  Future<List<Map<String, dynamic>>> getInsumosByFornecedor(
    int fornecedorId,
  ) async {
    return await repository.getInsumosByFornecedor(fornecedorId);
  }
}
