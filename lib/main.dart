import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Empreendimento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFFFEFD5), // your default color
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF825228),
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Aleo'),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFDEA9),
            foregroundColor: Color(0xFF7B3900),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            side: BorderSide(color: Color(0xFF7B3900), width: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            textStyle: TextStyle(fontSize: 24, fontFamily: 'Aleo'),
          ),
        ),
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
