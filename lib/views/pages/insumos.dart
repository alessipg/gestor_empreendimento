import 'package:flutter/material.dart';
import 'package:gestor_empreendimento/controllers/insumo_controller.dart';
import 'package:gestor_empreendimento/models/insumo.dart';
import 'package:gestor_empreendimento/repositories/insumo_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Insumos extends StatefulWidget {
  const Insumos({super.key});

  @override
  State<Insumos> createState() => _InsumosState();
}

class _InsumosState extends State<Insumos> {
  final insumoController = InsumoController(InsumoRepository());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Insumos')),
      body: Consumer<InsumoController>(
        builder: (context, insumoController, child) => ListView.builder(
          itemCount: insumoController.insumos.length,
          itemBuilder: (context, index) {
            final List<Insumo> insumo = insumoController.insumos;
            return ListTile(
              title: Text(insumo[index].nome), // ajuste conforme seu modelo
              subtitle: Text(insumo[index].quantidade.toString() ?? ''),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push('/insumos/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
