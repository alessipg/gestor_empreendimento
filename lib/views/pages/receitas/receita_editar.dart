import 'package:flutter/material.dart';
import 'package:receitacerta/controllers/receita_controller.dart';
import 'package:receitacerta/models/receita.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receitacerta/config/constants.dart';

class ReceitaEditar extends StatefulWidget {
  final Receita receita;

  const ReceitaEditar({super.key, required this.receita});

  @override
  State<ReceitaEditar> createState() => _ReceitaEditarState();
}

class _ReceitaEditarState extends State<ReceitaEditar> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nomeController.text = widget.receita.nome;
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    try {
      final receitaAtualizada = Receita(
        id: widget.receita.id,
        nome: nomeController.text,
        materiaPrima: widget.receita.consumoPorUnidade,
        produto: widget.receita.produto,
        qtdMercadoriaGerada: 1, // valor já usado no construtor
      );

      context.read<ReceitaController>().update(receitaAtualizada);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receita editada com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao editar receita")));
    }

    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final receita = widget.receita;

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          // Título
          Center(
            child: Text(
              'Receita de ${receita.nome}',
              style: TextStyle(
                fontSize: 24,
                color: UserColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nome da receita (único campo editável)
          TextFormField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome da receita',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um nome.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Mercadoria (somente leitura)
          TextFormField(
            initialValue: receita.produto.nome,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Mercadoria gerada',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color.fromARGB(255, 220, 206, 183),
            ),
          ),
          const SizedBox(height: 20),

          // Lista de insumos (somente leitura)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Insumos da receita:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...receita.consumoPorUnidade.entries.map((entry) {
                final insumo = entry.key;
                final quantidade = entry.value;
                return ListTile(
                  title: Text(
                    "$quantidade ${insumo.medida.sigla} de ${insumo.nome}",
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // Botão salvar (apenas nome é atualizado)
          Consumer<ReceitaController>(
            builder: (context, receitaController, _) {
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
                    'Salvar Alterações',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
