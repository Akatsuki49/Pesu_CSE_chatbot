import 'package:flutter/material.dart';
import 'message_text.dart';

class MessageContainer extends StatelessWidget {
  final String message;
  final bool isMe;
  final double screenwidth;
  final EdgeInsets messagePadding;

  const MessageContainer({
    super.key,
    required this.message,
    required this.isMe,
    required this.screenwidth,
    required this.messagePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: messagePadding,
      decoration: BoxDecoration(
        color: isMe ? const Color(0xff00377A) : Colors.white,
        borderRadius: BorderRadius.circular(isMe ? 13 : 333),
      ),
      child: MessageText(
        message: message,
        isMe: isMe,
        screenwidth: screenwidth,
      ),
    );
  }
}
