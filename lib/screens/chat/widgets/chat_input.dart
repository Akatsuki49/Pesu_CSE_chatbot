import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSubmitted;

  const ChatInput({super.key, required this.onSubmitted});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _handleSubmit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmitted(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Type a message'),
              onSubmitted: (_) => _handleSubmit(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
