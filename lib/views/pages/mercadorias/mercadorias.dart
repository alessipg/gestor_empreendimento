import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/mercadoria_controller.dart';
import 'package:receitacerta/views/widgets/delete_buttons/delete_mercadoria_btn.dart';
import 'package:receitacerta/views/widgets/list_app.dart';
import 'package:receitacerta/views/widgets/text_field_app.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Mercadorias extends StatefulWidget {
  const Mercadorias({super.key});

  @override
  State<Mercadorias> createState() => _MercadoriasState();
}

class _MercadoriasState extends State<Mercadorias> {
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
            'Mercadorias',
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
          hintText: 'Buscar mercadoria',
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          onChanged: (_) => setState(() {}),
        ),
        Consumer<MercadoriaController>(
          builder: (context, controller, _) {
            final mercadoriaFiltradas = controller.filtrarPorNome(
              nomeController.text,
            );

            return Column(
              children: [
                if (mercadoriaFiltradas.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhuma mercadoria encontrada.',
                        style: TextStyle(
                          fontSize: 20,
                          color: UserColor.secondary,
                        ),
                      ),
                    ),
                  )
                else
                  ListApp(
                    children: mercadoriaFiltradas
                        .map(
                          (mercadoria) => ListTile(
                            title: Text(mercadoria.nome),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              right: 8,
                            ),
                            onTap: () {
                              GoRouter.of(
                                context,
                              ).push('/mercadorias/edit', extra: mercadoria);
                            },
                            subtitle: Text(
                              'Preço: R\$ ${mercadoria.venda.toStringAsFixed(2).replaceAll('.', ',')} por ${mercadoria.medida.sigla}\n'
                              'Estoque: ${mercadoria.quantidade} ${mercadoria.medida.sigla} \n'
                              'Menor custo: R\$ ${mercadoria.custo.toStringAsFixed(2).replaceAll('.', ',')} por ${mercadoria.medida.sigla}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Image.asset(Img.edit),
                                  onPressed: () {
                                    GoRouter.of(context).push(
                                      '/mercadorias/edit',
                                      extra: mercadoria,
                                    );
                                  },
                                ),
                                DeleteMercadoriaButton(
                                  parentContext: context,
                                  mercadoriaId: mercadoria.id,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 16),

                // Botão sempre aparece (independente de ter ou não mercadorias)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: !isKeyboardOpen
                      ? ElevatedButton(
                          key: const ValueKey('nova_mercadoria_btn'),
                          onPressed: () =>
                              GoRouter.of(context).push('/mercadorias/add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UserColor.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
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
                                'Nova Mercadoria',
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
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
