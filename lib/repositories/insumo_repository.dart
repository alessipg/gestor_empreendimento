import 'package:gestor_empreendimento/models/insumo.dart';

class InsumoRepository {
  List<Insumo> _insumos = [];
  List<Insumo> get insumos => _insumos;

  InsumoRepository() {
    // Dados fictícios para exemplo
    _insumos = [
      Insumo(id: 1, nome: 'Farinha de trigo', custo: 10.0, quantidade: 100),
      Insumo(id: 2, nome: 'Açúcar', custo: 20.0, quantidade: 200),
      Insumo(id: 3, nome: 'Sal', custo: 30.0, quantidade: 300),
    ];
  }
}
