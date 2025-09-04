import 'package:flutter/material.dart';
import 'package:gestor_empreendimento/models/mercadoria.dart';
import 'package:gestor_empreendimento/config/constants.dart';
import 'package:go_router/go_router.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: CircleAvatar(
              radius: 18,
              backgroundColor: UserColor.colorLogo,
              child: Icon(
                Icons.person_2_sharp,
                color: UserColor.secondary,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => GoRouter.of(context).pop(),
                  borderRadius: BorderRadius.circular(25),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: UserColor.secondary,
                    child: Icon(
                      Icons.arrow_back,
                      color: UserColor.background,
                      size: 30,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Handle more options button press
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: UserColor.secondary,
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: UserColor.background,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/receitas'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
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
            SizedBox(height: 32),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context).push('/mercadorias'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage(Img.bread), width: 24, height: 24),
                    const SizedBox(width: 8),
                    const Text('Mercadorias'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage(Img.wheat), width: 24, height: 24),
                    const SizedBox(width: 8),
                    const Text('Insumos'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
