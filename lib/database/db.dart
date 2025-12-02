import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;
    return await _initDatabase();
  }

_initDatabase() async {
  final path = join(await getDatabasesPath(), 'receitacerta.db');
  return await openDatabase(
    path,
    version: 3,
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
  );
}


  _onCreate(db, version) async {
    await db.execute(_insumo);
    await db.execute(_mercadoria);
    await db.execute(_receita);
    await db.execute(_receitaInsumo);
    await db.execute(_fornecedor);
    await db.execute(_fornecedorInsumo);
    await _insertInitialData(db);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(_fornecedor);
      await db.execute(_fornecedorInsumo);
    }
    if (oldVersion < 3) {
      // Migração para versão 3: adiciona campo data_cadastro e remove constraint UNIQUE
      await db.execute('DROP TABLE IF EXISTS fornecedor_insumo_temp');
      await db.execute('''CREATE TABLE fornecedor_insumo_temp (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fornecedor_id INTEGER NOT NULL,
        insumo_id INTEGER NOT NULL,
        preco REAL NOT NULL,
        data_cadastro TEXT NOT NULL,
        FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id),
        FOREIGN KEY (insumo_id) REFERENCES insumo (id)
      )''');
      
      // Copia dados existentes adicionando data atual
      await db.execute('''INSERT INTO fornecedor_insumo_temp (id, fornecedor_id, insumo_id, preco, data_cadastro)
        SELECT id, fornecedor_id, insumo_id, preco, datetime('now', 'localtime') FROM fornecedor_insumo''');
      
      await db.execute('DROP TABLE fornecedor_insumo');
      await db.execute('ALTER TABLE fornecedor_insumo_temp RENAME TO fornecedor_insumo');
    }
  }

  String get _insumo => '''
    CREATE TABLE insumo (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      quantidade REAL NOT NULL,
      custo REAL NOT NULL,
      medida TEXT NOT NULL,
      isDiscreto INTEGER NOT NULL
    );
  ''';

  String get _mercadoria => '''
    CREATE TABLE mercadoria (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      quantidade REAL NOT NULL,
      custo REAL NOT NULL,
      venda REAL NOT NULL,
      medida TEXT NOT NULL,
      isDiscreto INTEGER NOT NULL
    );
  ''';

  String get _receita => '''
    CREATE TABLE receita (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      produto_id INTEGER NOT NULL,
      custoUnitario REAL NOT NULL,
      qtdMercadoriaGerada REAL NOT NULL,
      FOREIGN KEY (produto_id) REFERENCES mercadoria (id)
    );
  ''';

  String get _receitaInsumo => '''
    CREATE TABLE receita_insumo (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      receita_id INTEGER NOT NULL,
      insumo_id INTEGER NOT NULL,
      quantidadePorUnidade REAL NOT NULL,
      FOREIGN KEY (receita_id) REFERENCES receita (id),
      FOREIGN KEY (insumo_id) REFERENCES insumo (id),
      UNIQUE(receita_id, insumo_id)
    );
  ''';

  String get _fornecedor => '''
    CREATE TABLE fornecedor (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      cnpj TEXT,
      telefone TEXT,
      email TEXT,
      cep TEXT,
      endereco TEXT,
      bairro TEXT,
      cidade TEXT,
      estado TEXT
    );
  ''';

  String get _fornecedorInsumo => '''
    CREATE TABLE fornecedor_insumo (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      fornecedor_id INTEGER NOT NULL,
      insumo_id INTEGER NOT NULL,
      preco REAL NOT NULL,
      data_cadastro TEXT NOT NULL,
      FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id),
      FOREIGN KEY (insumo_id) REFERENCES insumo (id)
    );
  ''';

  _insertInitialData(Database db) async {
    // Inserir insumos iniciais
    await db.insert('insumo', {
      'nome': 'Farinha de trigo',
      'quantidade': 5.0,
      'custo': 15.0,
      'medida': 'kg',
      'isDiscreto': 0,
    });
    await db.insert('insumo', {
      'nome': 'Ovo',
      'quantidade': 12.0,
      'custo': 12.0,
      'medida': 'un',
      'isDiscreto': 1,
    });
    await db.insert('insumo', {
      'nome': 'Leite',
      'quantidade': 1.0,
      'custo': 5.0,
      'medida': 'l',
      'isDiscreto': 0,
    });

    // Inserir mercadorias iniciais
    await db.insert('mercadoria', {
      'nome': 'Pão francês',
      'quantidade': 50.0,
      'custo': 1.0,
      'venda': 1.5,
      'medida': 'un',
      'isDiscreto': 1,
    });
    await db.insert('mercadoria', {
      'nome': 'Bolo de chocolate',
      'quantidade': 20.0,
      'custo': 15.0,
      'venda': 10.0,
      'medida': 'un',
      'isDiscreto': 1,
    });
    await db.insert('mercadoria', {
      'nome': 'Torta de maçã',
      'quantidade': 10.0,
      'custo': 25.0,
      'venda': 40.0,
      'medida': 'un',
      'isDiscreto': 1,
    });
    await db.insert('mercadoria', {
      'nome': 'Pão',
      'quantidade': 0.0,
      'custo': 0.0,
      'venda': 0.0,
      'medida': 'un',
      'isDiscreto': 0,
    });
    await db.insert('mercadoria', {
      'nome': 'Bolo',
      'quantidade': 0.0,
      'custo': 0.0,
      'venda': 0.0,
      'medida': 'un',
      'isDiscreto': 0,
    });

    // Inserir receitas iniciais
    await db.insert('receita', {
      'nome': 'Pão',
      'produto_id': 4, // Pão
      'custoUnitario': 16.0, // (15*1 + 12*1 + 5*1) / 2
      'qtdMercadoriaGerada': 2.0,
    });
    await db.insert('receita', {
      'nome': 'Bolo',
      'produto_id': 5, // Bolo
      'custoUnitario': 51.0, // (15*2 + 12*3 + 5*0.5) / 1
      'qtdMercadoriaGerada': 1.0,
    });

    // Inserir relacionamentos receita-insumo
    // Receita Pão (id=1)
    await db.insert('receita_insumo', {
      'receita_id': 1,
      'insumo_id': 1, // Farinha de trigo
      'quantidadePorUnidade': 0.5, // 1kg / 2 unidades
    });
    await db.insert('receita_insumo', {
      'receita_id': 1,
      'insumo_id': 2, // Ovo
      'quantidadePorUnidade': 0.5, // 1 ovo / 2 unidades
    });
    await db.insert('receita_insumo', {
      'receita_id': 1,
      'insumo_id': 3, // Leite
      'quantidadePorUnidade': 0.5, // 1L / 2 unidades
    });

    // Receita Bolo (id=2)
    await db.insert('receita_insumo', {
      'receita_id': 2,
      'insumo_id': 1, // Farinha de trigo
      'quantidadePorUnidade': 2.0, // 2kg / 1 unidade
    });
    await db.insert('receita_insumo', {
      'receita_id': 2,
      'insumo_id': 2, // Ovo
      'quantidadePorUnidade': 3.0, // 3 ovos / 1 unidade
    });
    await db.insert('receita_insumo', {
      'receita_id': 2,
      'insumo_id': 3, // Leite
      'quantidadePorUnidade': 0.5, // 0.5L / 1 unidade
    });

    // Inserir fornecedores iniciais
    await db.insert('fornecedor', {
      'nome': 'Distribuidora Alimentos Ltda',
      'cnpj': '12.345.678/0001-90',
      'telefone': '(42) 3220-1234',
      'email': 'contato@distribuidora.com.br',
      'cep': '84010-000',
      'endereco': 'Rua XV de Novembro',
      'bairro': 'Centro',
      'cidade': 'Ponta Grossa',
      'estado': 'PR',
    });
    await db.insert('fornecedor', {
      'nome': 'Atacado Regional',
      'telefone': '(42) 3225-5678',
      'email': 'vendas@atacadoregional.com.br',
      'cidade': 'Ponta Grossa',
      'estado': 'PR',
    });

    // Inserir preços fornecedor-insumo
    // Distribuidora Alimentos (id=1)
    await db.insert('fornecedor_insumo', {
      'fornecedor_id': 1,
      'insumo_id': 1, // Farinha de trigo
      'preco': 12.5, // R$ 12,50/kg
      'data_cadastro': DateTime.now().toIso8601String(),
    });
    await db.insert('fornecedor_insumo', {
      'fornecedor_id': 1,
      'insumo_id': 3, // Leite
      'preco': 4.8, // R$ 4,80/L
      'data_cadastro': DateTime.now().toIso8601String(),
    });
    // Atacado Regional (id=2)
    await db.insert('fornecedor_insumo', {
      'fornecedor_id': 2,
      'insumo_id': 1, // Farinha de trigo
      'preco': 13.0, // R$ 13,00/kg
      'data_cadastro': DateTime.now().toIso8601String(),
    });
    await db.insert('fornecedor_insumo', {
      'fornecedor_id': 2,
      'insumo_id': 2, // Ovo
      'preco': 0.9, // R$ 0,90/un
      'data_cadastro': DateTime.now().toIso8601String(),
    });
  }
}
