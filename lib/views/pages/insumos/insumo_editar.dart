import 'package:flutter/material.dart';
import 'package:receitacerta/controllers/insumo_controller.dart';
import 'package:receitacerta/utils/currency_input_formatter.dart';
import 'package:receitacerta/utils/quantity_input_formatter.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/config/medida.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class InsumoEditar extends StatefulWidget {
  const InsumoEditar({super.key, required this.insumo});

  final Insumo insumo;

  @override
  State<InsumoEditar> createState() => _InsumoEditarState();
}

class _InsumoEditarState extends State<InsumoEditar> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nomeController;
  late final TextEditingController quantidadeController;
  late final TextEditingController custoController;
  late Medida selectedMedida;

  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.insumo.nome);

    // --- Quantidade (3 casas decimais fixas) ---
    final rawQuantity = (widget.insumo.quantidade * math.pow(10, 3))
        .toInt()
        .toString();

    final formattedQuantity = QuantityInputFormatter()
        .formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: rawQuantity),
        )
        .text;

    quantidadeController = TextEditingController(text: formattedQuantity);

    // --- Custo (2 casas decimais fixas) ---
    final rawCost = (widget.insumo.custo * 100).toInt().toString();

    final formattedCost = CurrencyInputFormatter()
        .formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: rawCost),
        )
        .text;

    custoController = TextEditingController(text: formattedCost);

    selectedMedida = widget.insumo.medida;
  }

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    custoController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _finishEdit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        context.read<InsumoController>().update(
          Insumo(
            id: widget.insumo.id,
            nome: nomeController.text,
            quantidade: QuantityInputFormatter.getCleanValue(
              quantidadeController.text,
            ),
            custo: CurrencyInputFormatter.getCleanValue(custoController.text),
            medida: selectedMedida,
            isDiscreto: widget.insumo.isDiscreto,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insumo atualizado com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Insumo com este id não encontrado.")),
        );
      }

      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Nome e botão de edição
            if (!_isEditing)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Editar ${nomeController.text}",
                        style: const TextStyle(
                          fontSize: 28,
                          color: UserColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.tightFor(width: 32, height: 32),
                    icon: Image.asset(Img.edit),
                    onPressed: _toggleEdit,
                  ),
                ],
              )
            else
              TextFormField(
                controller: nomeController,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18, color: UserColor.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um nome válido';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _finishEdit(),
              ),
            const SizedBox(height: 24),

            // Quantidade
            TextFormField(
              controller: quantidadeController,
              inputFormatters: [QuantityInputFormatter()],
              decoration: InputDecoration(
                labelText: 'Quantidade em ${selectedMedida.nome}',
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
            const SizedBox(height: 16),

            // Custo
            TextFormField(
              controller: custoController,
              inputFormatters: [CurrencyInputFormatter()],
              decoration: InputDecoration(
                labelText:
                    'Custo por ${selectedMedida.nome.substring(0, selectedMedida.nome.length - 1)}',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Medida dropdown
            DropdownButtonFormField<Medida>(
              initialValue: selectedMedida,
              decoration: const InputDecoration(
                labelText: 'Medida',
                border: OutlineInputBorder(),
              ),
              items: Medida.values.map((Medida medida) {
                return DropdownMenuItem<Medida>(
                  value: medida,
                  child: Text(medida.nome),
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
            const SizedBox(height: 32),

            // Botão Salvar
            Center(
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: UserColor.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Salvar alterações',
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
