import 'package:flutter/material.dart';
import 'package:gestor_empreendimento/gen/fonts.gen.dart';
import 'package:gestor_empreendimento/gen/assets.gen.dart';
import 'package:gestor_empreendimento/models/mercadoria.dart';
import 'package:gestor_empreendimento/pages/mercadorias.dart';

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
            backgroundColor: Color(0xFFFFB845),
            child: Text(
              '\$',
              style: TextStyle(
                color: Color(0xFF825228),
                fontSize: 24,
                fontFamily: FontFamily.annieUseYourTelescope,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFFFB845),
              child: Icon(
                Icons.person_2_sharp,
                color: Color(0xFF825228),
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
                  onTap: () {
                    // Handle back button press
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF825228),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFFFFEFD5),
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
                    backgroundColor: Color(0xFF825228),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Color(0xFFFFEFD5),
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
                onPressed: () {
                  // Handle button press
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(Assets.images.recipeBook.keyName),
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
                onPressed: () {
                  // Handle button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Mercadorias()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(Assets.images.bread.keyName),
                      width: 24,
                      height: 24,
                    ),
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
                    Image(
                      image: AssetImage(Assets.images.wheat.keyName),
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
    );
  }
}
