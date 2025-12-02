import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/fornecedor_controller.dart';
import 'package:receitacerta/models/insumo.dart';
import 'package:receitacerta/utils/currency_input_formatter.dart';
import 'package:intl/intl.dart';

class InsumoFornecedores extends StatefulWidget {
  const InsumoFornecedores({super.key, required this.insumo});

  final Insumo insumo;

  @override
  State<InsumoFornecedores> createState() => _InsumoFornecedoresState();
}

class _InsumoFornecedoresState extends State<InsumoFornecedores> {
  List<Map<String, dynamic>> _fornecedoresComPreco = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFornecedores();
  }

  Future<void> _loadFornecedores() async {
    final fornecedorController = context.read<FornecedorController>();
    final result = await fornecedorController.getFornecedoresComPrecoByInsumo(
      widget.insumo.id!,
    );
    setState(() {
      _fornecedoresComPreco = result;
      _isLoading = false;
    });
  }

  void _showAddFornecedorModal() {
    final fornecedorController = context.read<FornecedorController>();
    final fornecedoresDisponiveis = fornecedorController.getAll();

    if (fornecedoresDisponiveis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum fornecedor cadastrado no sistema'),
        ),
      );
      return;
    }

    int? selectedFornecedorId;
    final precoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adicionar Fornecedor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: UserColor.primary,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Fornecedor',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                items: fornecedoresDisponiveis.map((f) {
                  return DropdownMenuItem(
                    value: f.id,
                    child: Text(
                      f.nome,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedFornecedorId = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: precoController,
                decoration: InputDecoration(
                  labelText: 'Preço por ${widget.insumo.medida.sigla}',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyInputFormatter()],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedFornecedorId != null &&
                          precoController.text.isNotEmpty) {
                        final preco = CurrencyInputFormatter.getCleanValue(
                          precoController.text,
                        );
                        await fornecedorController.addInsumoPrice(
                          selectedFornecedorId!,
                          widget.insumo.id!,
                          preco,
                        );
                        Navigator.pop(context);
                        _loadFornecedores();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fornecedor adicionado com sucesso!'),
                          ),
                        );
                      }
                    },
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UserColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPrecoModal(Map<String, dynamic> fornecedor) {
    final precoController = TextEditingController(
      text: CurrencyInputFormatter()
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(
              text: (fornecedor['preco'] * 100).toInt().toString(),
            ),
          )
          .text,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Preço - ${fornecedor['nome']}'),
        content: TextFormField(
          controller: precoController,
          decoration: InputDecoration(
            labelText: 'Preço por ${widget.insumo.medida.sigla}',
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [CurrencyInputFormatter()],
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.black, fontSize: 18)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (precoController.text.isNotEmpty) {
                final preco = CurrencyInputFormatter.getCleanValue(
                  precoController.text,
                );
                await context.read<FornecedorController>().updateInsumoPrice(
                      fornecedor['preco_id'],
                      preco,
                    );
                Navigator.pop(context);
                _loadFornecedores();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preço atualizado!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UserColor.primary,
            ),
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _removeFornecedor(Map<String, dynamic> fornecedor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Fornecedor'),
        content: Text(
          'Deseja remover ${fornecedor['nome']} desta lista?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<FornecedorController>().removeInsumoPrice(
                    fornecedor['preco_id'],
                  );
              Navigator.pop(context);
              _loadFornecedores();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fornecedor removido!')),
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fornecedoresComPreco.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum fornecedor cadastrado para este insumo',
                    style: TextStyle(
                      fontSize: 18,
                      color: UserColor.secondary,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _fornecedoresComPreco.length,
                  itemBuilder: (context, index) {
                    final fornecedor = _fornecedoresComPreco[index];
                    final dataCadastro = DateTime.parse(fornecedor['data_cadastro']);
                    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(dataCadastro);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                fornecedor['nome'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (fornecedor['cidade'] != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  fornecedor['cidade'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'R\$ ${fornecedor['preco'].toStringAsFixed(2)}/${widget.insumo.medida.sigla}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cadastrado em: $dataFormatada',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 96,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showEditPrecoModal(fornecedor),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _removeFornecedor(fornecedor),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFornecedorModal,
        backgroundColor: UserColor.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
