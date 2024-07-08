import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSubmitted;

  const ChatInput({super.key, required this.onSubmitted});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  void _handleSubmit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmitted(_controller.text);
      _controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenwidth * 0.04, vertical: screenheight * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: screenheight *
                  0.06, // Adjust this value to set the height of the TextField
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: (_) => _handleSubmit(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenwidth * 0.03,
                    vertical: screenheight * 0.01,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Message",
                  fillColor: Colors.white70,
                  suffixIcon: _isFocused
                      ? IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _handleSubmit,
                        )
                      : null,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.headphones_rounded, size: screenwidth * 0.09),
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
