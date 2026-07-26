import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CbseApp());
}

class CbseApp extends StatelessWidget {
  const CbseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CBSE Class 5 Paper Bank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const HomeScreen(),
    );
  }
}