import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const GoQuizApp());
}

class GoQuizApp extends StatelessWidget {
  const GoQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoQuiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}