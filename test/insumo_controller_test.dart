import 'package:flutter_test/flutter_test.dart';
import 'package:receitacerta/config/medida.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:receitacerta/controllers/insumo_controller.dart';
import 'package:receitacerta/repositories/insumo_repository.dart';

void main() {
  test('Inserção correta no estoque', () {
    final insumoController = InsumoController(InsumoRepository());
    insumoController.criar(
      Insumo(
        id: 1,
        nome: 'Farinha de trigo',
        custo: 15,
        quantidade: 5,
        medida: Medida.kg,
        isDiscreto: false,
      ),
    );
    expect(insumoController.repository.insumos[0].custo, equals(3));
    insumoController.criar(
      Insumo(
        id: 2,
        nome: 'Ovo',
        custo: 15,
        quantidade: 12,
        medida: Medida.un,
        isDiscreto: true,
      ),
    );
    expect(insumoController.repository.insumos[1].custo, equals(1.25));
    insumoController.criar(
      Insumo(
        id: 3,
        nome: 'Leite',
        custo: 5,
        quantidade: 1,
        medida: Medida.l,
        isDiscreto: false,
      ),
    );
    expect(insumoController.repository.insumos[2].custo, equals(5));
  });
}
