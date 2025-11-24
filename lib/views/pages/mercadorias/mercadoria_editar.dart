import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/models/mercadoria.dart';
import 'package:flutter/material.dart';
import 'package:receitacerta/controllers/mercadoria_controller.dart';
import 'package:receitacerta/utils/currency_input_formatter.dart';
import 'package:receitacerta/utils/quantity_input_formatter.dart';
import 'package:provider/provider.dart';

class MercadoriaEditar extends StatefulWidget {
  final Mercadoria mercadoria;

  const MercadoriaEditar({super.key, required this.mercadoria});

  @override
  State<MercadoriaEditar> createState() => _MercadoriaEditarState();
}

class _MercadoriaEditarState extends State<MercadoriaEditar> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nomeController.text = widget.mercadoria.nome;
    precoController.text = widget.mercadoria.venda.toStringAsFixed(2);
  }

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // Atualiza os dados da mercadoria
      final valorVenda = CurrencyInputFormatter.getCleanValue(
        precoController.text,
      );

      final quantidade = QuantityInputFormatter.getCleanValue(
        quantidadeController.text,
      );

      try {
        context.read<MercadoriaController>().update(
          Mercadoria(
            id: widget.mercadoria.id,
            nome: nomeController.text,
            custo: widget.mercadoria.custo,
            venda: valorVenda,
            quantidade: quantidade,
            medida: widget.mercadoria.medida,
            isDiscreto: widget.mercadoria.isDiscreto,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mercadoria atualizada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mercadoria com este id não encontrada.'),
          ),
        );
      }

      Navigator.pop(context, widget.mercadoria);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mercadoria = widget.mercadoria;

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          // Título
          Center(
            child: Text(
              'Mercadoria: ${mercadoria.nome}',
              style: TextStyle(
                fontSize: 24,
                color: UserColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nome da mercadoria
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

          // Preço da mercadoria
          TextFormField(
            controller: precoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Preço da mercadoria',
              border: OutlineInputBorder(),
              prefixText: 'R\$ ',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o preço da mercadoria';
              }
              final parsed = double.tryParse(value.replaceAll(',', '.'));
              if (parsed == null || parsed < 0) {
                return 'Por favor, insira um preço válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Quantidade da mercadoria
          TextFormField(
            controller: quantidadeController,
            inputFormatters: [QuantityInputFormatter()],
            decoration: InputDecoration(
              labelText: 'Quantidade em ${mercadoria.medida.nome}',
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira uma quantidade';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Botão de salvar
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
                'Salvar',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
