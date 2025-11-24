import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/security/GoogleSignInService.dart';

class AppBarUser extends StatelessWidget implements PreferredSizeWidget {
  const AppBarUser({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar logout"),
        content: const Text("Você tem certeza que deseja sair da conta?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await GoogleSignInService.signOut();
                context.push('/menu');
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erro no login: $e')));
              }
            },
            child: const Text("Sair"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: UserColor.colorLogo,
          child: Text(
            '\$',
            style: TextStyle(
              color: UserColor.secondary,
              fontSize: 24,
              fontFamily: Font.annieUseYourTelescope,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: Icon(Icons.logout, color: UserColor.colorLogo, size: 30),
            onPressed: () => _showLogoutDialog(context),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
