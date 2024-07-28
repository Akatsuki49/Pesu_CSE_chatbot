import 'package:flutter/material.dart';

class MessageIcon extends StatelessWidget {
  final double screenwidth;

  const MessageIcon({super.key, required this.screenwidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: screenwidth * 0.005),
      child: Icon(
        Icons.circle,
        color: Color.fromARGB(255, 243, 126, 0),
        size: screenwidth * 0.036,
      ),
    );
  }
}
