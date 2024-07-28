import 'package:flutter/material.dart';

class DisclaimerInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const DisclaimerInfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xff00377A)),
        SizedBox(width: 10.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenwidth * 0.042,
              color: const Color.fromARGB(255, 44, 44, 44),
            ),
          ),
        ),
      ],
    );
  }
}
