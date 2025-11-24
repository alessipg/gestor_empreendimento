import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/receita_controller.dart';
import 'package:provider/provider.dart';

class DeleteReceitaButton extends StatelessWidget {
  final BuildContext parentContext;
  final int? receitaId;

  const DeleteReceitaButton({
    super.key,
    required this.parentContext,
    required this.receitaId,
  });

  void _deleteMercadoria() {
    if (receitaId == null) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text("Erro: ID do insumo não encontrado")),
      );
      return;
    }

    final controller = Provider.of<ReceitaController>(
      parentContext,
      listen: false,
    );

    controller.delete(receitaId!);

    ScaffoldMessenger.of(parentContext).showSnackBar(
      const SnackBar(content: Text("Receita excluída com sucesso")),
    );
  }

  void _confirmDelete(BuildContext context) {
    if (receitaId == null) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text("Não é possível excluir: ID inválido")),
      );
      return;
    }

    showDialog(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Receita"),
        content: const Text("Tem certeza que deseja excluir esta receita?"),
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
      onPressed: receitaId == null ? null : () => _confirmDelete(context),
    );
  }
}
