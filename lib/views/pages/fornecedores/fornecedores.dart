import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/fornecedor_controller.dart';
import 'package:receitacerta/views/widgets/delete_buttons/delete_fornecedor_btn.dart';
import 'package:receitacerta/views/widgets/list_app.dart';
import 'package:receitacerta/views/widgets/text_field_app.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Fornecedores extends StatefulWidget {
  const Fornecedores({super.key});

  @override
  State<Fornecedores> createState() => _FornecedoresState();
}

class _FornecedoresState extends State<Fornecedores> {
  final TextEditingController nomeController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Fornecedores',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              color: UserColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFieldApp(
          textController: nomeController,
          hintText: 'Buscar fornecedor',
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          onChanged: (_) => setState(() {}),
        ),
        Consumer<FornecedorController>(
          builder: (context, controller, _) {
            final fornecedoresFiltrados = controller.filtrarPorNome(
              nomeController.text,
            );

            return Column(
              children: [
                if (fornecedoresFiltrados.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Nenhum fornecedor encontrado.',
                      style: TextStyle(
                        fontSize: 20,
                        color: UserColor.secondary,
                      ),
                    ),
                  )
                else
                  ListApp(
                    children: fornecedoresFiltrados
                        .map(
                          (fornecedor) => ListTile(
                            title: Text(fornecedor.nome),
                            subtitle: Text(
                              [
                                if (fornecedor.cidade != null)
                                  fornecedor.cidade,
                                if (fornecedor.telefone != null)
                                  fornecedor.telefone,
                              ].join(' • '),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              right: 8,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    GoRouter.of(context).push(
                                      '/fornecedores/edit',
                                      extra: fornecedor,
                                    );
                                  },
                                  icon: const Image(
                                    image: AssetImage(Img.edit),
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                DeleteFornecedorBtn(fornecedor: fornecedor),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                if (!isKeyboardOpen)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).push('/fornecedores/add');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UserColor.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 12,
                        ),
                        alignment: Alignment.center,
                        fixedSize: const Size(210, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Novo Fornecedor',
                            style: TextStyle(
                              fontFamily: Font.aleo,
                              fontSize: 20,
                              color: UserColor.secondaryContainer,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.add_circle_outline,
                            color: UserColor.secondaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
