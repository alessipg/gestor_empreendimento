import 'package:flutter/material.dart';

class Mercadorias extends StatefulWidget {
  const Mercadorias({super.key});

  @override
  State<Mercadorias> createState() => _MercadoriasState();
}

class _MercadoriasState extends State<Mercadorias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercadorias'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Mercadoria 1'),
            subtitle: Text('Descrição da Mercadoria 1'),
          ),
          ListTile(
            title: Text('Mercadoria 2'),
            subtitle: Text('Descrição da Mercadoria 2'),
          ),
          // Add more ListTiles as needed
        ],
      ),
    );
  }
}
