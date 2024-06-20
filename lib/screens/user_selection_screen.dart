import 'package:flutter/material.dart';

import './auth/student_login_screen.dart';
import './auth/staff_login_screen.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('sah.ai')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please select one:'),
            ElevatedButton(
              child: const Text('I\'m a student'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const StudentLoginScreen();
                    },
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('I\'m a staff'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StaffLoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
