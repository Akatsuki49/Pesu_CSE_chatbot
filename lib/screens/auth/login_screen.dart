import 'package:flutter/material.dart';
import 'package:sahai/screens/user_selection_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to sah.ai'),
            ElevatedButton(
              child: const Text('Get Started'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserTypeSelectionScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
