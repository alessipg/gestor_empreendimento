import 'package:receitacerta/database/db.dart';
import 'package:receitacerta/models/fornecedor.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FornecedorRepository extends ChangeNotifier {
  late Database db;
  List<Fornecedor> _fornecedores = [];
  List<Fornecedor> get fornecedores => _fornecedores;
  bool _isInitialized = false;

  FornecedorRepository() {
    _initRepository();
  }

  _initRepository() async {
    db = await DB.instance.database;
    await _loadFornecedores();
    _isInitialized = true;
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  _loadFornecedores() async {
    final List<Map<String, dynamic>> maps = await db.query('fornecedor');
    _fornecedores = List.generate(maps.length, (i) {
      return Fornecedor.fromMap(maps[i]);
    });
    print(
      '📦 Carregados ${_fornecedores.length} fornecedores do banco: ${_fornecedores.map((f) => f.nome).join(", ")}',
    );
    notifyListeners();
  }

  Future<void> addFornecedor(Fornecedor fornecedor) async {
    final id = await db.insert('fornecedor', fornecedor.toMap());
    fornecedor.id = id;
    _fornecedores.add(fornecedor);
    print('✅ Fornecedor adicionado ao banco: ${fornecedor.nome} (ID: $id)');
    notifyListeners();
  }

  Future<void> updateFornecedor(Fornecedor fornecedor) async {
    await db.update(
      'fornecedor',
      fornecedor.toMap(),
      where: 'id = ?',
      whereArgs: [fornecedor.id],
    );
    final index = _fornecedores.indexWhere((f) => f.id == fornecedor.id);
    if (index != -1) {
      _fornecedores[index] = fornecedor;
      notifyListeners();
    }
  }

  Future<void> deleteFornecedor(int id) async {
    // Remove relacionamentos primeiro
    await db.delete(
      'fornecedor_insumo',
      where: 'fornecedor_id = ?',
      whereArgs: [id],
    );
    // Remove fornecedor
    await db.delete('fornecedor', where: 'id = ?', whereArgs: [id]);
    _fornecedores.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  Future<void> addInsumoPrice(
    int fornecedorId,
    int insumoId,
    double preco,
  ) async {
    await db.insert('fornecedor_insumo', {
      'fornecedor_id': fornecedorId,
      'insumo_id': insumoId,
      'preco': preco,
      'data_cadastro': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  Future<void> updateInsumoPrice(int precoId, double preco) async {
    await db.update(
      'fornecedor_insumo',
      {'preco': preco},
      where: 'id = ?',
      whereArgs: [precoId],
    );
    notifyListeners();
  }

  Future<void> removeInsumoPrice(int precoId) async {
    await db.delete('fornecedor_insumo', where: 'id = ?', whereArgs: [precoId]);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getFornecedoresComPrecoByInsumo(
    int insumoId,
  ) async {
    final result = await db.rawQuery(
      '''
      SELECT f.id, f.nome, f.cidade, fi.id as preco_id, fi.preco, fi.data_cadastro
      FROM fornecedor f
      INNER JOIN fornecedor_insumo fi ON f.id = fi.fornecedor_id
      WHERE fi.insumo_id = ?
      ORDER BY fi.data_cadastro DESC
    ''',
      [insumoId],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getInsumosByFornecedor(
    int fornecedorId,
  ) async {
    final result = await db.rawQuery(
      '''
      SELECT i.*, fi.preco
      FROM insumo i
      INNER JOIN fornecedor_insumo fi ON i.id = fi.insumo_id
      WHERE fi.fornecedor_id = ?
    ''',
      [fornecedorId],
    );
    return result;
  }
}
