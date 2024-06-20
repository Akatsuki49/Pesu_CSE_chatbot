import 'package:flutter/material.dart';
import './widgets/message_bubble.dart';
import './widgets/chat_input.dart';

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('sah.ai Chat')),
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
    );
  }
}
