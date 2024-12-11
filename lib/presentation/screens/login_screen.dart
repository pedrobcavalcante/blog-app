import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Modular.to.pushReplacementNamed('/home');
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
