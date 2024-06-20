import 'package:flutter/material.dart';
import 'package:sahai/screens/chat/text_chat_screen.dart';
import 'package:sahai/widgets/custom_textfield.dart';
import '../../../widgets/custom_button.dart';

class StudentLoginScreen extends StatelessWidget {
  const StudentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomTextField(labelText: 'SRN'),
            const SizedBox(height: 20),
            const CustomTextField(labelText: 'Password', obscureText: true),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Login',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TextChatScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
