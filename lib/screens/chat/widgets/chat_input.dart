import 'dart:ui';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final Color inputColor;
  final Color inputBackgroundColor;

  const ChatInput({
    super.key,
    required this.onSubmitted,
    required this.focusNode,
    required this.inputColor,
    required this.inputBackgroundColor,
  });

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
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
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
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
              height: screenheight * 0.052,
              child: TextField(
                cursorColor: widget.inputColor,
                controller: _controller,
                focusNode: widget.focusNode,
                style: TextStyle(color: widget.inputColor), // Text color
                onSubmitted: (_) => _handleSubmit(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenwidth * 0.05,
                    vertical: screenheight * 0.01,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(
                          255, 216, 216, 216), // Enabled border color
                      width: 1.5, // Thicker enabled border
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(
                          255, 216, 216, 216), // Enabled border color
                      width: 1.5, // Thicker enabled border
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(
                          255, 216, 216, 216), // Enabled border color
                      width: 1.5, // Thicker enabled border
                    ),
                  ),
                  filled: true,
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 182, 182, 182),
                      fontWeight: FontWeight.w400), // Hint text color
                  hintText: "Message",
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  suffixIcon: _isFocused
                      ? IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Color(0xFF4D4D4D),
                          ),
                          onPressed: _handleSubmit,
                        )
                      : null,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.headphones_rounded,
              size: screenwidth * 0.09,
              color: Color(0xFF4D4D4D),
            ),
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
