import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/config/medida.dart';
import 'package:receitacerta/controllers/mercadoria_controller.dart';
import 'package:receitacerta/controllers/receita_controller.dart';
import 'package:receitacerta/utils/currency_input_formatter.dart';
import 'package:receitacerta/utils/quantity_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MercadoriaCriar extends StatefulWidget {
  const MercadoriaCriar({super.key});

  @override
  State<MercadoriaCriar> createState() => _MercadoriaCriarState();
}

class _MercadoriaCriarState extends State<MercadoriaCriar> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController vendaController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  Medida selectedMedida = Medida.kg;

  @override
  void dispose() {
    nomeController.dispose();
    vendaController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      final valorVenda = CurrencyInputFormatter.getCleanValue(
        vendaController.text,
      );

      final quantidade = QuantityInputFormatter.getCleanValue(
        quantidadeController.text,
      );
      try {
        context.read<MercadoriaController>().criar(
          nomeController.text,
          valorVenda,
          quantidade,
          selectedMedida,
          context.read<ReceitaController>(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mercadoria criada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mercadoria com este nome já existe.')),
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
            Center(
              child: Text(
                'Criar Mercadoria',
                style: TextStyle(
                  fontSize: 24,
                  color: UserColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nome
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da mercadoria',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome da mercadoria';
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
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecione uma medida.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: quantidadeController,
              inputFormatters: [QuantityInputFormatter()], // ✅ apply mask
              decoration: InputDecoration(
                labelText: 'Quantidade em ${selectedMedida.nome}',
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

            // Venda
            TextFormField(
              controller: vendaController,
              inputFormatters: [CurrencyInputFormatter()],
              decoration: const InputDecoration(
                labelText: 'Preço de venda',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Insira um preço de venda';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Consumer<MercadoriaController>(
              builder: (context, controller, child) {
                return Center(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
