import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: buildHomeScreen(), // Home screen as the default page
    );
  }
}
