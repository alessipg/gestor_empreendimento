import 'package:flutter/material.dart';
import 'package:receitacerta/views/widgets/delete_buttons/delete_receita_btn.dart';
import 'package:receitacerta/views/widgets/text_field_app.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receitacerta/views/widgets/list_app.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/receita_controller.dart';

class Receitas extends StatefulWidget {
  const Receitas({super.key});

  @override
  State<Receitas> createState() => _ReceitasState();
}

class _ReceitasState extends State<Receitas> {
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
            'Receitas',
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
          hintText: 'Buscar receita',
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          onChanged: (_) => setState(() {}),
        ),
        Consumer<ReceitaController>(
          builder: (context, controller, _) {
            final receitasFiltradas = controller.filtrarPorNome(
              nomeController.text,
            );

            return Column(
              children: [
                if (receitasFiltradas.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Nenhuma receita encontrada.',
                      style: TextStyle(
                        fontSize: 20,
                        color: UserColor.secondary,
                      ),
                    ),
                  )
                else
                  ListApp(
                    children: receitasFiltradas
                        .map(
                          (receita) => ListTile(
                            title: Text(receita.nome),
                            subtitle: Text(
                              'Custo: R\$ ${receita.custoUnitario.toStringAsFixed(2).replaceAll('.', ',')} por ${receita.produto.medida.sigla}',
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              right: 8,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Image.asset(Img.edit),
                                  onPressed: () {
                                    GoRouter.of(
                                      context,
                                    ).push('/receitas/edit', extra: receita);
                                  },
                                ),
                                DeleteReceitaButton(
                                  parentContext: context,
                                  receitaId: receita.id,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 16),

                // Botão sempre aparece (independente de ter ou não receitas)
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
                          key: const ValueKey('nova_receita_btn'),
                          onPressed: () =>
                              GoRouter.of(context).push('/receitas/add'),
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
                                'Nova Receita',
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
