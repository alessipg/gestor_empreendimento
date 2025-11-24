import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:go_router/go_router.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: UserColor.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () => GoRouter.of(context).pop(),
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: UserColor.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer(); // abre o Drawer
              },
              icon: Icon(Icons.more_vert, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
