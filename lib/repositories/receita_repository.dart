import 'package:receitacerta/database/db.dart';
import 'package:receitacerta/models/receita.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:receitacerta/models/mercadoria.dart';
import 'package:receitacerta/config/medida.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ReceitaRepository extends ChangeNotifier {
  late Database db;
  List<Receita> _receitas = [];
  List<Receita> get receitas => _receitas;
  bool _isInitialized = false;

  ReceitaRepository() {
    _initRepository();
  }

  
  _initRepository() async {
    db = await DB.instance.database;
    await _loadReceitas();
    _isInitialized = true;
  }

  Future<void> waitForInitialization() async {
    while (!_isInitialized) {
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  _loadReceitas() async {
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT r.*, m.nome as produto_nome, m.custo as produto_custo, 
             m.venda as produto_venda, m.quantidade as produto_quantidade,
             m.medida as produto_medida, m.isDiscreto as produto_isDiscreto
      FROM receita r
      JOIN mercadoria m ON r.produto_id = m.id
    ''');

    _receitas = [];
    for (var map in maps) {
      // Create produto from joined data
      final produto = Mercadoria(
        id: map['produto_id'],
        nome: map['produto_nome'],
        custo: map['produto_custo'].toDouble(),
        venda: map['produto_venda'].toDouble(),
        quantidade: map['produto_quantidade'].toDouble(),
        medida: Medida.fromString(map['produto_medida']),
        isDiscreto: map['produto_isDiscreto'] == 1,
      );

      // Load insumos for this receita
      final insumoMaps = await db.rawQuery(
        '''
        SELECT ri.*, i.nome, i.custo, i.quantidade, i.medida, i.isDiscreto
        FROM receita_insumo ri
        JOIN insumo i ON ri.insumo_id = i.id
        WHERE ri.receita_id = ?
      ''',
        [map['id']],
      );

      final consumoPorUnidade = <Insumo, double>{};
      for (var insumoMap in insumoMaps) {
        final insumo = Insumo(
          id: insumoMap['insumo_id'] as int?,
          nome: insumoMap['nome'] as String,
          custo: (insumoMap['custo'] as num).toDouble(),
          quantidade: (insumoMap['quantidade'] as num).toDouble(),
          medida: Medida.fromString(insumoMap['medida'] as String),
          isDiscreto: insumoMap['isDiscreto'] == 1,
        );
        consumoPorUnidade[insumo] = (insumoMap['quantidadePorUnidade'] as num)
            .toDouble();
      }

      final receita = Receita.fromDatabase(
        id: map['id'],
        nome: map['nome'],
        produto: produto,
        custoUnitario: map['custoUnitario'].toDouble(),
        qtdMercadoriaGerada: map['qtdMercadoriaGerada'].toDouble(),
        consumoPorUnidade: consumoPorUnidade,
      );

      _receitas.add(receita);
    }
    notifyListeners();
  }

  Future<void> addReceita(Receita receita) async {
    // Insert receita
    final receitaMap = receita.toMap();
    receitaMap.remove('id'); // Remove id for insert
    final receitaId = await db.insert('receita', receitaMap);

    // Insert receita-insumo relationships
    for (var entry in receita.consumoPorUnidade.entries) {
      await db.insert('receita_insumo', {
        'receita_id': receitaId,
        'insumo_id': entry.key.id,
        'quantidadePorUnidade': entry.value,
      });
    }

    receita.id = receitaId;
    _receitas.add(receita);
    notifyListeners();
  }

  Future<void> updateReceita(Receita receita) async {
    // Update receita
    await db.update(
      'receita',
      receita.toMap(),
      where: 'id = ?',
      whereArgs: [receita.id],
    );

    // Delete existing receita-insumo relationships
    await db.delete(
      'receita_insumo',
      where: 'receita_id = ?',
      whereArgs: [receita.id],
    );

    // Insert new receita-insumo relationships
    for (var entry in receita.consumoPorUnidade.entries) {
      await db.insert('receita_insumo', {
        'receita_id': receita.id,
        'insumo_id': entry.key.id,
        'quantidadePorUnidade': entry.value,
      });
    }

    final index = _receitas.indexWhere((r) => r.id == receita.id);
    if (index != -1) {
      _receitas[index] = receita;
      notifyListeners();
    }
  }

  Future<void> deleteReceita(int id) async {
    // Delete receita-insumo relationships first (cascade)
    await db.delete('receita_insumo', where: 'receita_id = ?', whereArgs: [id]);

    // Delete receita
    await db.delete('receita', where: 'id = ?', whereArgs: [id]);

    _receitas.removeWhere((receita) => receita.id == id);
    notifyListeners();
  }

  Receita? getReceitaById(int id) {
    try {
      return _receitas.firstWhere((receita) => receita.id == id);
    } catch (e) {
      return null;
    }
  }
}
