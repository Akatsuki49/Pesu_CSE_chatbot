// lib/screens/chat/text_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import 'package:sahai/screens/auth/landing_page.dart';
import './widgets/message_bubble.dart';
import './widgets/chat_input.dart';

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({Key? key}) : super(key: key);

  @override
  _TextChatScreenState createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final List<String> _messages = [];

  void _handleSubmitted(String text) {
    setState(() {
      _messages.insert(0, text);
    });
  }

  Future<void> _handleLogout() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      await AuthService().signOut();
      Provider.of<UserProvider>(context, listen: false).clearUser();

      // Hide loading indicator
      Navigator.of(context).pop();

      // Pop until we reach the LandingPage
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('sah.ai Chat'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: _handleLogout,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) =>
                    MessageBubble(message: _messages[index]),
              ),
            ),
            ChatInput(onSubmitted: _handleSubmitted),
          ],
        ),
      ),
    );
  }
}
