import 'package:flutter/material.dart';
import 'package:receitacerta/controllers/fornecedor_controller.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/models/fornecedor.dart';
import 'package:provider/provider.dart';

class DeleteFornecedorBtn extends StatelessWidget {
  final Fornecedor fornecedor;

  const DeleteFornecedorBtn({super.key, required this.fornecedor});

  void _deleteFornecedor(BuildContext context) {
    if (fornecedor.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro: ID do fornecedor não encontrado")),
      );
      return;
    }

    final controller = Provider.of<FornecedorController>(
      context,
      listen: false,
    );

    controller.deletar(fornecedor.id!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fornecedor excluído com sucesso")),
    );
  }

  void _confirmDelete(BuildContext context) {
    if (fornecedor.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não é possível excluir: ID inválido")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Fornecedor"),
        content: Text("Tem certeza que deseja excluir ${fornecedor.nome}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteFornecedor(context);
            },
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _confirmDelete(context),
      icon: const Image(image: AssetImage(Img.remove), width: 24, height: 24),
    );
  }
}
