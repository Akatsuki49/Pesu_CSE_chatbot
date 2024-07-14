import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  bool isMe;

  MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenwidth * 0.06,
        vertical: screenheight * 0.01,
      ),
      child: !isMe
          ? Row(
              children: [
                Icon(Icons.circle,
                    color: Color(0xff4D4D4D), size: screenwidth * 0.036),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenwidth * 0.04,
                      vertical: screenheight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      message,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenwidth * 0.04,
                  vertical: screenheight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Color(0xff00377A),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
    );
  }
}
