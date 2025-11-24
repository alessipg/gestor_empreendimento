import 'package:flutter/material.dart';
import 'package:receitacerta/controllers/insumo_controller.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:provider/provider.dart';

class DeleteInsumoButton extends StatelessWidget {
  final BuildContext parentContext;
  final int? insumoId;

  const DeleteInsumoButton({
    super.key,
    required this.parentContext,
    required this.insumoId,
  });

  void _deleteInsumo() {
    if (insumoId == null) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text("Erro: ID do insumo não encontrado")),
      );
      return;
    }

    final controller = Provider.of<InsumoController>(
      parentContext,
      listen: false,
    );

    controller.delete(insumoId!);

    ScaffoldMessenger.of(parentContext).showSnackBar(
      const SnackBar(content: Text("Insumo excluído com sucesso")),
    );
  }

  void _confirmDelete(BuildContext context) {
    if (insumoId == null) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text("Não é possível excluir: ID inválido")),
      );
      return;
    }

    showDialog(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Insumo"),
        content: const Text("Tem certeza que deseja excluir este insumo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteInsumo();
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(Img.remove),
      // Desabilita se não houver id
      onPressed: insumoId == null ? null : () => _confirmDelete(context),
    );
  }
}
