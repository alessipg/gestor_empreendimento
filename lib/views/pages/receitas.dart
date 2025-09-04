import 'package:flutter/material.dart';

class Receitas extends StatefulWidget {
  const Receitas
({super.key});

  @override
  State<Receitas> createState() => _ReceitasState();
}

class _ReceitasState extends State<Receitas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Receita 1'),
            subtitle: Text('Descrição da Receita 1'),
          ),
          ListTile(
            title: Text('Receita 2'),
            subtitle: Text('Descrição da Receita 2'),
          ),
          // Add more ListTiles as needed
        ],
      ),
    );
  }
}