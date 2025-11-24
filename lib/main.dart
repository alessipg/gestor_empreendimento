import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/insumo_controller.dart';
import 'package:receitacerta/repositories/insumo_repository.dart';
import 'package:receitacerta/controllers/receita_controller.dart';
import 'package:receitacerta/repositories/receita_repository.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'controllers/mercadoria_controller.dart';
import 'repositories/mercadoria_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receitacerta/security/GoogleSignInService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await GoogleSignInService.initSignIn();

  // Initialize repositories and wait for database loading
  final insumoRepository = InsumoRepository();
  final mercadoriaRepository = MercadoriaRepository();
  final receitaRepository = ReceitaRepository();

  await Future.wait([
    insumoRepository.waitForInitialization(),
    mercadoriaRepository.waitForInitialization(),
    receitaRepository.waitForInitialization(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InsumoController(insumoRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => MercadoriaController(mercadoriaRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => ReceitaController(
            receitaRepository,
            context.read<InsumoController>(),
            context.read<MercadoriaController>(),
          ),
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gestor de Empreendimento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: UserColor.background,
        appBarTheme: AppBarTheme(
          backgroundColor: UserColor.secondary,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.apply(fontFamily: Font.aleo),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: UserColor.secondaryContainer,
            foregroundColor: UserColor.primary,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            side: BorderSide(color: UserColor.primary, width: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            textStyle: TextStyle(fontSize: 24, fontFamily: Font.aleo),
          ),
        ),
      ),
      routerConfig: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
