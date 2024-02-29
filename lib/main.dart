import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xo2_app/screens/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return const MaterialApp(
      home: Scaffold(backgroundColor: Colors.redAccent, body: HomeScreen()),
    );
  }
}
