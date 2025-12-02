import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/mercadoria_controller.dart';
import 'package:receitacerta/models/mercadoria.dart';
import 'package:receitacerta/views/widgets/text_field_app.dart';

class SearchMercadoriaModal extends StatefulWidget {
  final Function(Mercadoria) onItemSelected;

  const SearchMercadoriaModal({super.key, required this.onItemSelected});

  @override
  State<SearchMercadoriaModal> createState() => _SearchMercadoriaModalState();
}

class _SearchMercadoriaModalState extends State<SearchMercadoriaModal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Text(
              "Buscar Mercadoria",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: UserColor.primary,
              ),
            ),
            const SizedBox(height: 16),
            TextFieldApp(
              textController: _searchController,
              hintText: 'Digite o nome...',
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              onChanged: (val) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<MercadoriaController>(
                builder: (context, controller, _) {
                  final results = controller.filtrarPorNome(
                    _searchController.text,
                  );

                  if (results.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma mercadoria encontrada."),
                    );
                  }

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final mercadoria = results[index];
                      return ListTile(
                        title: Text(mercadoria.nome),
                        subtitle: Text(
                          "R\$ ${mercadoria.venda.toStringAsFixed(2)}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: UserColor.primary,
                          ),
                          onPressed: () {
                            widget.onItemSelected(mercadoria);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
