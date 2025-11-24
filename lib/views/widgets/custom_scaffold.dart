import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/views/widgets/app_bar_actions.dart';
import 'package:receitacerta/views/widgets/app_bar_user.dart';
import 'package:go_router/go_router.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;

  const CustomScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // padrão já é true
      appBar: AppBarUser(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: UserColor.secondary),
              child: Text(
                "Bem-vinda!",
                style: TextStyle(
                  color: UserColor.primaryContainer,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                "Home",
                style: TextStyle(
                  fontFamily: Font.annieUseYourTelescope,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              onTap: () => GoRouter.of(context).push('/menu'),
            ),
            ListTile(
              leading: const Image(
                image: AssetImage(Img.recipeBook),
                width: 24,
                height: 24,
              ),
              title: const Text(
                "Receitas",
                style: TextStyle(
                  fontFamily: Font.annieUseYourTelescope,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              onTap: () => GoRouter.of(context).push('/receitas'),
            ),
            ListTile(
              leading: const Image(
                image: AssetImage(Img.bread),
                width: 24,
                height: 24,
              ),
              title: const Text(
                "Mercadorias",
                style: TextStyle(
                  fontFamily: Font.annieUseYourTelescope,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              onTap: () => GoRouter.of(context).push('/mercadorias'),
            ),
            ListTile(
              leading: const Image(
                image: AssetImage(Img.wheat),
                width: 24,
                height: 24,
              ),
              title: const Text(
                "Insumos",
                style: TextStyle(
                  fontFamily: Font.annieUseYourTelescope,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              onTap: () => GoRouter.of(context).push('/insumos'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppBarActions(),
            Expanded(child: child),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
