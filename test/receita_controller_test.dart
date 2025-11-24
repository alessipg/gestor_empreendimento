/*import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_empreendimento/config/medida.dart';
import 'package:gestor_empreendimento/controllers/mercadoria_controller.dart';
import 'package:gestor_empreendimento/models/insumo.dart';
import 'package:gestor_empreendimento/models/mercadoria.dart';
import 'package:gestor_empreendimento/controllers/insumo_controller.dart';
import 'package:gestor_empreendimento/controllers/receita_controller.dart';
import 'package:gestor_empreendimento/repositories/insumo_repository.dart';
import 'package:gestor_empreendimento/repositories/receita_repository.dart';

void main() {
  test('Criação de receita calcula custo corretamente', () {
    // Crie insumos fictícios
    final insumo1 = Insumo(
      id: 1,
      nome: 'Farinha de trigo',
      custo: 15,
      quantidade: 5,
      medida: Medida.kg,
      isDiscreto: false,
    );
    final insumo2 = Insumo(
      id: 2,
      nome: 'Ovo',
      custo: 12,
      quantidade: 12,
      medida: Medida.un,
      isDiscreto: true,
    );
    final insumo3 = Insumo(
      id: 3,
      nome: 'Leite',
      custo: 5,
      quantidade: 1,
      medida: Medida.l,
      isDiscreto: false,
    );

    // Crie mercadoria fictícia
    final mercadoria = Mercadoria(
      id: 1,
      nome: 'Pão',
      custo: 0.0,
      venda: 0.0,
      quantidade: 0,
      medida: Medida.un,
      isDiscreto: false,
    );

    ReceitaController receitaController = ReceitaController(
      ReceitaRepository(),
      InsumoController(),
      MercadoriaController
    );
    receitaController.criar(
      'Pão',
      {
        insumo1: 1.0, // 2 kg de farinha
        insumo2: 1.0, // 1 ovo
        insumo3: 1.0, // 0.5 litros de leite
      },
      mercadoria,
      2,
    );
    final receitaRepository = receitaController.receitas;
    // Verifique o custo calculado
    // O custo é calculado como:
    // soma de (custo do insumo * quantidade por unidade * quantidade de produto)
    final receita = receitaRepository[0];
    expect(receita.custoUnitario, equals(4.5));
  });
}
*/
