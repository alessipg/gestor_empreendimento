import 'package:flutter/material.dart';
import 'package:gestor_empreendimento/gen/assets.gen.dart';
import 'package:gestor_empreendimento/gen/fonts.gen.dart';
import 'package:gestor_empreendimento/pages/menu.dart';
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
                fontFamily: FontFamily.annieUseYourTelescope,
                fontSize: 80,
                color: Color(0xFF7B3900),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // goes to menu.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Menu()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7B3900),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(Assets.images.googleLogo.keyName, height: 30),
                  const SizedBox(width: 8),
                  const Text(
                    'Entrar com Google',
                    style: TextStyle(
                      fontFamily: FontFamily.aleo,
                      fontSize: 18,
                      color: Color(0xFFFFEFD5),
                    ),
                  ),
                ],
              ),
            
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFFFEFD5),
    );
  }
}
