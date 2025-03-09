import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Add this import

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final timeFormat = DateFormat('HH:mm'); // Time formatter

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: screenHeight * 0.01,
      ),
      child: !isMe
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 17.0),
                  child: Icon(
                    Icons.circle,
                    color: const Color(0xff4D4D4D),
                    size: screenWidth * 0.036,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          timeFormat.format(timestamp),
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff00377A),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      timeFormat.format(timestamp),
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
