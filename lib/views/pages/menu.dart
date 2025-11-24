import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:go_router/go_router.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/receitas'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage(Img.recipeBook),
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text('Receitas'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/mercadorias'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage(Img.bread),
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text('Mercadorias'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/insumos'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage(Img.wheat),
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text('Insumos'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Badge(
        isLabelVisible: false,
        child: FloatingActionButton(
          onPressed: () {
            GoRouter.of(context).push('/carrinho');
          },
          backgroundColor: UserColor.primary,
          child: const Icon(
            Icons.shopping_cart,
            color: UserColor.secondaryContainer,
          ),
        ),
      ),
    );
  }
}
