import 'package:flutter/material.dart';
import 'package:vegetableapp/pages/home_screen.dart';

void main() {
  runApp(const VegetableApp());
}

class VegetableApp extends StatelessWidget {
  const VegetableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vegetable app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "SFProDisplay"
      ),
      home: const HomeScreen(),
    );
  }
}