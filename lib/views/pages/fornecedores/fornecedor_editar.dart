import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitacerta/models/fornecedor.dart';
import 'package:go_router/go_router.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/fornecedor_controller.dart';
import 'package:receitacerta/services/viacep_service.dart';

class FornecedorEditar extends StatefulWidget {
  const FornecedorEditar({super.key, required this.fornecedor});

  final Fornecedor fornecedor;

  @override
  State<FornecedorEditar> createState() => _FornecedorEditarState();
}

class _FornecedorEditarState extends State<FornecedorEditar> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nomeController;
  late final TextEditingController cnpjController;
  late final TextEditingController telefoneController;
  late final TextEditingController emailController;
  late final TextEditingController cepController;
  late final TextEditingController enderecoController;
  late final TextEditingController bairroController;
  late final TextEditingController cidadeController;
  late final TextEditingController estadoController;

  bool _isLoadingCep = false;
  bool _isLoadingCnpj = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.fornecedor.nome);
    cnpjController = TextEditingController(text: widget.fornecedor.cnpj ?? '');
    telefoneController = TextEditingController(
      text: widget.fornecedor.telefone ?? '',
    );
    emailController = TextEditingController(
      text: widget.fornecedor.email ?? '',
    );
    cepController = TextEditingController(text: widget.fornecedor.cep ?? '');
    enderecoController = TextEditingController(
      text: widget.fornecedor.endereco ?? '',
    );
    bairroController = TextEditingController(
      text: widget.fornecedor.bairro ?? '',
    );
    cidadeController = TextEditingController(
      text: widget.fornecedor.cidade ?? '',
    );
    estadoController = TextEditingController(
      text: widget.fornecedor.estado ?? '',
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    cnpjController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    cepController.dispose();
    enderecoController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  Future<void> _buscarCep() async {
    final cep = cepController.text;
    if (cep.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Digite um CEP')));
      return;
    }

    setState(() {
      _isLoadingCep = true;
    });

    final resultado = await ViaCepService.buscarCep(cep);

    setState(() {
      _isLoadingCep = false;
    });

    if (resultado != null) {
      setState(() {
        enderecoController.text = resultado['logradouro'] ?? '';
        bairroController.text = resultado['bairro'] ?? '';
        cidadeController.text = resultado['localidade'] ?? '';
        estadoController.text = resultado['uf'] ?? '';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CEP encontrado!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CEP não encontrado')));
    }
  }

  Future<void> _buscarCnpj() async {
    final cnpj = cnpjController.text;
    if (cnpj.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Digite um CNPJ')));
      return;
    }

    setState(() {
      _isLoadingCnpj = true;
    });

    final resultado = await ViaCepService.buscarCnpj(cnpj);

    setState(() {
      _isLoadingCnpj = false;
    });

    if (resultado != null) {
      setState(() {
        nomeController.text = resultado['nome'] ?? '';
        telefoneController.text = resultado['telefone'] ?? '';
        emailController.text = resultado['email'] ?? '';
        cepController.text = resultado['cep'] ?? '';
        enderecoController.text =
            '${resultado['logradouro'] ?? ''} ${resultado['numero'] ?? ''}'
                .trim();
        bairroController.text = resultado['bairro'] ?? '';
        cidadeController.text = resultado['municipio'] ?? '';
        estadoController.text = resultado['uf'] ?? '';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CNPJ encontrado!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CNPJ não encontrado ou serviço indisponível'),
        ),
      );
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<FornecedorController>().atualizar(
        Fornecedor(
          id: widget.fornecedor.id,
          nome: nomeController.text,
          cnpj: cnpjController.text.isEmpty ? null : cnpjController.text,
          telefone: telefoneController.text.isEmpty
              ? null
              : telefoneController.text,
          email: emailController.text.isEmpty ? null : emailController.text,
          cep: cepController.text.isEmpty ? null : cepController.text,
          endereco: enderecoController.text.isEmpty
              ? null
              : enderecoController.text,
          bairro: bairroController.text.isEmpty ? null : bairroController.text,
          cidade: cidadeController.text.isEmpty ? null : cidadeController.text,
          estado: estadoController.text.isEmpty ? null : estadoController.text,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fornecedor atualizado com sucesso!')),
      );
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
              'Editar Fornecedor',
              style: TextStyle(fontSize: 24, color: UserColor.primary),
            ),
            const SizedBox(height: 16),

            // Nome
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do fornecedor *',
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

            // CNPJ com botão de busca
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cnpjController,
                    decoration: const InputDecoration(
                      labelText: 'CNPJ',
                      hintText: '00.000.000/0000-00',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final numeros = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (numeros.length != 14) {
                          return 'CNPJ deve ter 14 dígitos';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoadingCnpj ? null : _buscarCnpj,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UserColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: _isLoadingCnpj
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Telefone
            TextFormField(
              controller: telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                hintText: '(00) 0000-0000',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty && !value.contains('@')) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // CEP com botão de busca
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cepController,
                    decoration: const InputDecoration(
                      labelText: 'CEP',
                      hintText: '00000-000',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoadingCep ? null : _buscarCep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UserColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: _isLoadingCep
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),

            // Endereço
            TextFormField(
              controller: enderecoController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Bairro
            TextFormField(
              controller: bairroController,
              decoration: const InputDecoration(
                labelText: 'Bairro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Cidade
            TextFormField(
              controller: cidadeController,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Estado
            TextFormField(
              controller: estadoController,
              decoration: const InputDecoration(
                labelText: 'Estado',
                hintText: 'UF',
                border: OutlineInputBorder(),
              ),
              maxLength: 2,
            ),
            const SizedBox(height: 24),

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
                  'Salvar',
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
