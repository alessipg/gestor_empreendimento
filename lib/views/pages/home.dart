import 'package:flutter/material.dart';
import 'package:gestor_empreendimento/config/constants.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo!',
              style: TextStyle(
                fontFamily: Font.annieUseYourTelescope,
                fontSize: 80,
                color: UserColor.primary,
              ),
            ),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).push('/menu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: UserColor.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(Img.googleLogo, height: 30),
                  const SizedBox(width: 8),
                  const Text(
                    'Entrar com Google',
                    style: TextStyle(
                      fontFamily: Font.aleo,
                      fontSize: 18,
                      color: UserColor.secondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
