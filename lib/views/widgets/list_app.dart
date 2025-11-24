import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';

class ListApp extends StatelessWidget {
  const ListApp({super.key, required this.children});

  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.white : UserColor.secondaryContainer,
            border: Border.all(color: UserColor.primary, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: children[index],
        );
      },
    );
  }
}
