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
  bool _isSending = false;
  bool _isFocused = false;
  bool _showEmptyError = false;
  static const int _maxChars = 1000;
  static const Color _themeColor = Color(0xff00377A);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
          // Clear error when focusing back in the field
          if (_isFocused) _showEmptyError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final trimmed = _controller.text.trim();

    if (trimmed.isEmpty) {
      setState(() => _showEmptyError = true);
      _focusNode.requestFocus();
      return;
    }

    if (trimmed.length > _maxChars) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message too long (max 1000 chars)'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final messageText = trimmed;
    _controller.clear();

    setState(() {
      _isSending = true;
      _showEmptyError = false;
    });

    try {
      await widget.onSubmitted(messageText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final bottomInset = mediaQuery.viewInsets.bottom;

    // Adjust padding when keyboard is visible
    final verticalPadding =
        bottomInset > 0 ? screenHeight * 0.01 : screenHeight * 0.02;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: screenHeight * 0.15, // Max 15% of screen height
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null, // Allows unlimited lines
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                    onChanged: (text) {
                      // Clear error when typing
                      if (_showEmptyError && text.isNotEmpty) {
                        setState(() => _showEmptyError = false);
                      } else {
                        setState(() {});
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(
                        color: _themeColor.withOpacity(0.6),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.012,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                          color: _showEmptyError ? Colors.red : _themeColor,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                          color: _showEmptyError
                              ? Colors.red
                              : _themeColor.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                          color: _showEmptyError ? Colors.red : _themeColor,
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: _controller.text.isNotEmpty || _isFocused
                          ? Container(
                              margin: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: _themeColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: _isSending
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                onPressed: _isSending ? null : _handleSubmit,
                              ),
                            )
                          : null,
                      counter: Text(
                        "${_controller.text.length}/$_maxChars",
                        style: TextStyle(
                          color: _controller.text.length > _maxChars
                              ? Colors.red
                              : _themeColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Elegant error message that appears below the text field
          if (_showEmptyError)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                "Please enter a message",
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
