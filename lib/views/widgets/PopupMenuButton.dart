import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receitacerta/security/GoogleSignInService.dart';

class PopupMenuWithAlert extends StatelessWidget {
  const PopupMenuWithAlert({super.key});

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

  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Perfil selecionado")));
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Configurações selecionadas")),
        );
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(child: Text("Conteúdo principal da página")),
          Positioned(
            bottom: 20,
            right: 20,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 40, color: Colors.blue),
              onSelected: (value) => _onMenuSelected(context, value),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'profile', child: Text("Perfil")),
                const PopupMenuItem(
                  value: 'settings',
                  child: Text("Configurações"),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Logout"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
