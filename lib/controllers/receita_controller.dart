import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:receitacerta/controllers/mercadoria_controller.dart';
import 'package:receitacerta/models/mercadoria.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:receitacerta/repositories/receita_repository.dart';
import 'package:receitacerta/models/receita.dart';
import 'package:receitacerta/controllers/insumo_controller.dart';
import 'package:diacritic/diacritic.dart';

class ReceitaController extends ChangeNotifier {
  final ReceitaRepository repository;
  final InsumoController insumoController;
  final MercadoriaController mercadoriaController;

  int _idCounter = 0;

  ReceitaController(
    this.repository,
    this.insumoController,
    this.mercadoriaController,
  ) {
    _initializeController();
  }

  _initializeController() async {
    await repository.waitForInitialization();
    // 🔹 Garante que todas as receitas já existentes tenham ID
    for (final receita in repository.receitas) {
      if (receita.id == null) {
        receita.id = _idCounter++;
      } else if (receita.id! >= _idCounter) {
        // 🔹 Atualiza o contador para continuar dos maiores IDs existentes
        _idCounter = receita.id! + 1;
      }
    }
    notifyListeners();
  }

  UnmodifiableListView<Receita> get receitas =>
      UnmodifiableListView(repository.receitas);

  Future<void> criar(
    String nome,
    Map<Insumo, double> materiaPrima,
    Mercadoria mercadoria,
    int qtdMercadoria,
  ) async {
    final novaReceita = Receita(
      id: _idCounter++, // 🔹 ID só vem do controller
      nome: nome,
      produto: mercadoria,
      qtdMercadoriaGerada: qtdMercadoria.toDouble(),
      materiaPrima: materiaPrima,
    );

    await mercadoriaController.update(
      Mercadoria(
        id: mercadoria.id,
        nome: mercadoria.nome,
        venda: mercadoria.venda,
        custo: novaReceita.custoUnitario,
        quantidade: mercadoria.quantidade,
        medida: mercadoria.medida,
        isDiscreto: mercadoria.isDiscreto,
      ),
    );

    await repository.addReceita(novaReceita);

  }

  Future<void> update(Receita receita) async {
    final index = repository.receitas.indexWhere((r) => r.id == receita.id);
    if (index == -1) {
      throw Exception('Receita com id ${receita.id} não encontrada.');
    }
    await repository.updateReceita(receita);
  }

  Future<void> delete(int id) async {
    await repository.deleteReceita(id);
    notifyListeners();
  }

  Receita getById(int id) {
    return repository.receitas.firstWhere((receita) => receita.id == id);
  }

  List<Receita> getAll() => List.unmodifiable(repository.receitas);

  List<Receita> filtrarPorNome(String termo) {
    return receitas
        .where(
          (r) => removeDiacritics(
            r.nome.toLowerCase(),
          ).contains(removeDiacritics(termo.toLowerCase())),
        )
        .toList();
  }
}
