import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:blog/app_module.dart';

void main() async {
  runApp(ModularApp(
    module: AppModule(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
    );
  }
}
