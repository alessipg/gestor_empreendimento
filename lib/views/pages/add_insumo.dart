import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestor_empreendimento/models/insumo.dart';
import 'package:gestor_empreendimento/controllers/insumo_controller.dart';
import 'package:go_router/go_router.dart';

// Tela temporária para adicionar um insumo

class AddInsumo extends StatelessWidget {
  const AddInsumo({super.key});

  @override
  Widget build(BuildContext context) {
    String nome = '';
    final insumoController = context.watch<InsumoController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Insumo')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome do Insumo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) => nome = value,
            ),
            SizedBox(height: 16), // Espaço entre o campo e o botão
            ElevatedButton(
              onPressed: () {
                insumoController.addInsumo(
                  Insumo(nome: nome, quantidade: 0, id: 1, custo: 20),
                );
                GoRouter.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
