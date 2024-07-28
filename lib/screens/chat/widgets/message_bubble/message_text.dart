import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageText extends StatelessWidget {
  final String message;
  final bool isMe;
  final double screenwidth;

  const MessageText({
    super.key,
    required this.message,
    required this.isMe,
    required this.screenwidth,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: GoogleFonts.inter(
        color: isMe ? Colors.white : Colors.black,
        fontSize: screenwidth * 0.043, // Adjust font size based on screen width
        height: 1.5, // Line height
      ),
    );
  }
}
