import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gestor_empreendimento/models/insumo.dart';
import 'package:gestor_empreendimento/repositories/insumo_repository.dart';

class InsumoController extends ChangeNotifier {
  InsumoRepository repository;
  InsumoController(this.repository);

  UnmodifiableListView<Insumo> get insumos => UnmodifiableListView(repository.insumos);

  void addInsumo(Insumo insumo) {
    repository.insumos.add(insumo);
    notifyListeners();
  }
}
