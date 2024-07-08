// lib/screens/chat/text_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import './widgets/message_bubble.dart';
import './widgets/chat_input.dart';

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key});

  @override
  _TextChatScreenState createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final Map<String, bool> _messages = {};

  void _handleSubmitted(String text) {
    setState(() {
      _messages[text] = true; //submitted by user
    });
  }

  Future<void> _handleLogout() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
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
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    _messages['Hello! How may I assist you today?'] = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: screenwidth * 0.38,
          leading: Image.asset(
            'assets/images/pesu_logo_png.png',
            width: screenwidth * 0.3,
            height: screenwidth * 0.3,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: screenwidth * 0.03),
              child: Image.asset('assets/images/sah.ai_greyText.png'),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final entry =
                      _messages.entries.toList().reversed.toList()[index];
                  final message = entry.key;
                  final isMe = entry.value;
                  return MessageBubble(
                    message: message,
                    isMe: isMe, //shuld be there per msg
                  );
                },
              ),
            ),
            ChatInput(onSubmitted: _handleSubmitted),
          ],
        ),
      ),
    );
  }
}
