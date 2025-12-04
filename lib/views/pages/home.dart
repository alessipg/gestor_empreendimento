import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:receitacerta/security/GoogleSignInService.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bem-vindo ao ReceiTaCerta!',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontFamily: Font.annieUseYourTelescope,
                  fontSize: 50,
                  color: UserColor.primary,
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  try {
                    //TODO: remover depois
                    final userCredential =
                        await GoogleSignInService.signInWithGoogle();
                    if (userCredential != null) {
                      // Login bem-sucedido
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro no login: $e')),
                    );
                  }
                  context.push('/menu');
                },
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
      ),
    );
  }
}
