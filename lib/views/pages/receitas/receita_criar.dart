import 'package:flutter/material.dart';
import 'package:receitacerta/controllers/insumo_controller.dart';
import 'package:receitacerta/controllers/mercadoria_controller.dart';
import 'package:receitacerta/controllers/receita_controller.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:receitacerta/models/mercadoria.dart';
import 'package:receitacerta/utils/quantity_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receitacerta/config/constants.dart';

class ReceitaCriar extends StatefulWidget {
  const ReceitaCriar({super.key});

  @override
  State<ReceitaCriar> createState() => _ReceitaCriarState();
}

class _ReceitaCriarState extends State<ReceitaCriar> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();

  final Map<String, TextEditingController> controllers = {};

  final List<Insumo> selectedItems = [];
  Mercadoria? selectedMercadoria;
  int qtdMercadoria = 0;

  @override
  void dispose() {
    nomeController.dispose();
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      try {
        final materiaPrima = controllers.map((nome, controller) {
          final insumo = context.read<InsumoController>().getAll().firstWhere(
            (i) => i.nome == nome,
            orElse: () => throw Exception('Insumo $nome não encontrado.'),
          );
          final quantidade = double.tryParse(
            controller.text.replaceAll(',', '.'),
          );
          if (quantidade == null) {
            throw Exception('Quantidade inválida para o insumo $nome.');
          }
          return MapEntry(insumo, quantidade);
        });

        context.read<ReceitaController>().criar(
          nomeController.text,
          materiaPrima,
          selectedMercadoria!,
          qtdMercadoria,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receita criada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Erro ao criar receita")));
      }

      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          // Título centralizado
          Center(
            child: Text(
              'Criar Receita',
              style: TextStyle(fontSize: 24, color: UserColor.primary),
            ),
          ),
          const SizedBox(height: 16),

          // Nome da receita
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

          // Dropdown MERCADORIAS
          Consumer<MercadoriaController>(
            builder: (context, controller, _) {
              final mercadorias = controller.getAll();
              if (mercadorias.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhuma mercadoria disponível. Adicione mercadorias primeiro.',
                    style: TextStyle(fontSize: 20, color: UserColor.secondary),
                  ),
                );
              }

              return DropdownButtonFormField<Mercadoria>(
                initialValue: null,
                hint: const Text("Selecione mercadoria"),
                items: mercadorias.map((mercadoria) {
                  return DropdownMenuItem(
                    value: mercadoria,
                    child: Text(mercadoria.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMercadoria = value;
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma mercadoria.';
                  }
                  return null;
                },
              );
            },
          ),

          const SizedBox(height: 20),

          // Quantidade da mercadoria
          TextFormField(
            decoration: InputDecoration(
              labelText: selectedMercadoria == null
                  ? 'Selecione uma mercadoria'
                  : 'Quantidade em ${selectedMercadoria!.medida.sigla}',
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                qtdMercadoria = int.tryParse(value) ?? 0;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma quantidade.';
              }
              final qtd = double.tryParse(value.replaceAll(',', '.'));
              if (qtd == null || qtd <= 0) {
                return 'Por favor, insira uma quantidade válida.';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Seleção de insumos
          Consumer<InsumoController>(
            builder: (context, controller, _) {
              final insumos = controller.getAll();
              if (insumos.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum insumo disponível. Adicione insumos primeiro.',
                    style: TextStyle(fontSize: 20, color: UserColor.secondary),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selecione insumos utilizados:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // Lista de checkboxes
                  ...insumos.map((insumo) {
                    return CheckboxListTile(
                      title: Text(insumo.nome),
                      value: selectedItems.contains(insumo),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            selectedItems.add(insumo);
                            controllers[insumo.nome] = TextEditingController();
                          } else {
                            selectedItems.remove(insumo);
                            controllers.remove(insumo.nome)?.dispose();
                          }
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  // Campos de quantidade + botão excluir
                  ...selectedItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controllers[item.nome],
                              keyboardType: TextInputType.number,
                              inputFormatters: [QuantityInputFormatter()],
                              decoration: InputDecoration(
                                labelText:
                                    "Quantidade de ${item.nome} em ${item.medida.sigla}",
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira uma quantidade.';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(width: 8),

                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedItems.remove(item);
                                controllers.remove(item.nome)?.dispose();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),
          Consumer2<ReceitaController, MercadoriaController>(
            builder: (context, receitaController, mercadoriaController, _) {
              // Button
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
    );
  }
}
