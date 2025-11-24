import 'package:receitacerta/database/db.dart';
import 'package:receitacerta/models/mercadoria.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class MercadoriaRepository extends ChangeNotifier {
  late Database db;
  List<Mercadoria> _mercadorias = [];
  List<Mercadoria> get mercadorias => _mercadorias;
  bool _isInitialized = false;

  MercadoriaRepository() {
    _initRepository();
  }

  _initRepository() async {
    db = await DB.instance.database;
    await _loadMercadorias();
    _isInitialized = true;
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  _loadMercadorias() async {
    final List<Map<String, dynamic>> maps = await db.query('mercadoria');
    _mercadorias = List.generate(maps.length, (i) {
      return Mercadoria.fromMap(maps[i]);
    });
    print(
      '📦 Carregadas ${_mercadorias.length} mercadorias do banco: ${_mercadorias.map((m) => m.nome).join(", ")}',
    );
    notifyListeners();
  }

  Future<void> addMercadoria(Mercadoria mercadoria) async {
    final id = await db.insert('mercadoria', mercadoria.toMap());
    mercadoria.id = id;
    _mercadorias.add(mercadoria);
    print('✅ Mercadoria adicionada ao banco: ${mercadoria.nome} (ID: $id)');
    notifyListeners();
  }

  Future<void> updateMercadoria(Mercadoria mercadoria) async {
    await db.update(
      'mercadoria',
      mercadoria.toMap(),
      where: 'id = ?',
      whereArgs: [mercadoria.id],
    );
    final index = _mercadorias.indexWhere((m) => m.id == mercadoria.id);
    if (index != -1) {
      _mercadorias[index] = mercadoria;
      notifyListeners();
    }
  }

  Future<void> deleteMercadoria(int id) async {
    await db.delete('mercadoria', where: 'id = ?', whereArgs: [id]);
    _mercadorias.removeWhere((mercadoria) => mercadoria.id == id);
    notifyListeners();
  }

  Mercadoria? getMercadoriaById(int id) {
    try {
      return _mercadorias.firstWhere((mercadoria) => mercadoria.id == id);
    } catch (e) {
      return null;
    }
  }
}
