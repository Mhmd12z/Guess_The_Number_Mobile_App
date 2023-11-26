import 'package:flutter/material.dart';
import './home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Guess The Number",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textTheme: const TextTheme(
              bodyLarge: TextStyle(fontFamily: 'PressStart2P'),
              bodyMedium: TextStyle(fontFamily: 'PressStart2P'),
              bodySmall: TextStyle(fontFamily: 'PressStart2P'))),
      home: const HomePage(),
    );
  }
}
