import 'package:a221_lab_ass_2/splashscreen.dart';
import 'package:flutter/material.dart';
//import 'views/splashscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homestay Raya',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const SplashScreen(),
    );
  }
}
