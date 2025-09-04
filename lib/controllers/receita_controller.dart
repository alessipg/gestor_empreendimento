import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'package:gestor_empreendimento/repositories/receita_repository.dart';
import 'package:gestor_empreendimento/models/receita.dart';

class ReceitaController extends ChangeNotifier {
  final ReceitaRepository repository;
  ReceitaController(this.repository);

  UnmodifiableListView<Receita> get receitas => UnmodifiableListView(repository.receitas);


  void criarReceita(Receita receita) {
    repository.receitas.add(receita);
    notifyListeners();
  }
}