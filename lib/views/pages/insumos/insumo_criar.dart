import 'package:flutter/material.dart';
import 'package:receitacerta/config/medida.dart';
import 'package:receitacerta/utils/currency_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:go_router/go_router.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/insumo_controller.dart';
import 'package:receitacerta/utils/quantity_input_formatter.dart';

class InsumoCriar extends StatefulWidget {
  const InsumoCriar({super.key});

  @override
  State<InsumoCriar> createState() => _InsumoCriarState();
}

class _InsumoCriarState extends State<InsumoCriar> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController custoController = TextEditingController();

  Medida selectedMedida = Medida.kg;
  double custoPorUnidade = 0;

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    custoController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      final double quantidade = QuantityInputFormatter.getCleanValue(
        quantidadeController.text,
      );
      try {
        context.read<InsumoController>().criar(
          Insumo(
            nome: nomeController.text,
            quantidade: quantidade,
            id: null,
            custo: custoPorUnidade,
            medida: selectedMedida,
            isDiscreto: false,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insumo criado com sucesso!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Insumo com este nome já existe")),
        );
      }

      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              'Criar Insumo',
              style: TextStyle(fontSize: 24, color: UserColor.primary),
            ),
            const SizedBox(height: 16),

            // Nome
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do insumo',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um nome.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<Medida>(
              initialValue: selectedMedida,
              decoration: const InputDecoration(
                labelText: 'Medida',
                border: OutlineInputBorder(),
              ),
              items: Medida.values.map((Medida medida) {
                return DropdownMenuItem<Medida>(
                  value: medida,
                  child: Row(
                    children: [
                      Text(medida.nome.toString()),
                      Text(' (${medida.toString().split('.').last})'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Medida? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedMedida = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Quantidade
            TextFormField(
              controller: quantidadeController,
              inputFormatters: [QuantityInputFormatter()], // ✅ apply mask
              decoration: InputDecoration(
                labelText: 'Quantidade total em ${selectedMedida.nome}',
                border: const OutlineInputBorder(),
              ),

              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma quantidade.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Custo
            TextFormField(
              controller: custoController,
              decoration: const InputDecoration(
                labelText: 'Custo total',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Custo por ${selectedMedida.nome.substring(0, selectedMedida.nome.length - 1)} calculado:',
                  style: TextStyle(fontSize: 16),
                ),
                ValueListenableBuilder(
                  valueListenable: custoController,
                  builder: (context, _, _) {
                    return ValueListenableBuilder(
                      valueListenable: quantidadeController,
                      builder: (context, _, _) {
                        // Use os métodos utilitários para obter valores limpos
                        final custo = CurrencyInputFormatter.getCleanValue(
                          custoController.text,
                        );
                        final quantidade = QuantityInputFormatter.getCleanValue(
                          quantidadeController.text,
                        );
                        custoPorUnidade = quantidade > 0
                            ? (custo / quantidade)
                            : 0;
                        return Text(
                          ' R\$ ${custoPorUnidade.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            // Dropdown
            const SizedBox(height: 16),

            // Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: UserColor.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Adicionar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
