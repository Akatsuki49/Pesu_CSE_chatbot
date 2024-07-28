import 'package:flutter/material.dart';
import 'message_icon.dart';
import 'message_container.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;

    EdgeInsets messagePadding = EdgeInsets.symmetric(
      horizontal: screenwidth * 0.04,
      vertical: screenheight * 0.01,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenwidth * 0.06,
        vertical: screenheight * 0.01,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) MessageIcon(screenwidth: screenwidth),
          MessageContainer(
            message: message,
            isMe: isMe,
            screenwidth: screenwidth,
            messagePadding: messagePadding,
          ),
        ],
      ),
    );
  }
}
