import 'package:receitacerta/database/db.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class InsumoRepository extends ChangeNotifier {
  late Database db;
  List<Insumo> _insumos = [];
  List<Insumo> get insumos => _insumos;
  bool _isInitialized = false;

  InsumoRepository() {
    _initRepository();
  }

  _initRepository() async {
    db = await DB.instance.database;
    await _loadInsumos();
    _isInitialized = true;
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  _loadInsumos() async {
    final List<Map<String, dynamic>> maps = await db.query('insumo');
    _insumos = List.generate(maps.length, (i) {
      return Insumo.fromMap(maps[i]);
    });
    print(
      '📦 Carregados ${_insumos.length} insumos do banco: ${_insumos.map((i) => i.nome).join(", ")}',
    );
    notifyListeners();
  }

  Future<void> addInsumo(Insumo insumo) async {
    final id = await db.insert('insumo', insumo.toMap());
    insumo.id = id;
    _insumos.add(insumo);
    print('✅ Insumo adicionado ao banco: ${insumo.nome} (ID: $id)');
    notifyListeners();
  }

  Future<void> updateInsumo(Insumo insumo) async {
    await db.update(
      'insumo',
      insumo.toMap(),
      where: 'id = ?',
      whereArgs: [insumo.id],
    );
    final index = _insumos.indexWhere((i) => i.id == insumo.id);
    if (index != -1) {
      _insumos[index] = insumo;
      notifyListeners();
    }
  }

  Future<void> deleteInsumo(int id) async {
    await db.delete('insumo', where: 'id = ?', whereArgs: [id]);
    _insumos.removeWhere((insumo) => insumo.id == id);
    notifyListeners();
  }

  Insumo? getInsumoById(int id) {
    try {
      return _insumos.firstWhere((insumo) => insumo.id == id);
    } catch (e) {
      return null;
    }
  }
}
