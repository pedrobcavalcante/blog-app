import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;

    return Drawer(
      backgroundColor: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: appBarHeight),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Usuário',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 40),
              ),
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              label: const Text('Sair', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
