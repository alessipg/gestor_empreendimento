import 'package:flutter/material.dart';
import 'package:receitacerta/controllers/mercadoria_controller.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:provider/provider.dart';

class DeleteMercadoriaButton extends StatelessWidget {
  final BuildContext parentContext;
  final int? mercadoriaId;

  const DeleteMercadoriaButton({
    super.key,
    required this.parentContext,
    required this.mercadoriaId,
  });

  void _deleteMercadoria() {
    if (mercadoriaId == null) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text("Erro: ID da mercadoria não encontrada")),
      );
      return;
    }

    final controller = Provider.of<MercadoriaController>(
      parentContext,
      listen: false,
    );

    controller.delete(mercadoriaId!);

    ScaffoldMessenger.of(parentContext).showSnackBar(
      const SnackBar(content: Text("Mercadoria excluída com sucesso")),
    );
  }

  void _confirmDelete(BuildContext context) {
    if (mercadoriaId == null) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text("Não é possível excluir: ID inválido")),
      );
      return;
    }

    showDialog(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Mercadoria"),
        content: const Text("Tem certeza que deseja excluir esta mercadoria?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteMercadoria();
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
      onPressed: mercadoriaId == null ? null : () => _confirmDelete(context),
    );
  }
}
