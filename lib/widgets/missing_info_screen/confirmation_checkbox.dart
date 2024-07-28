import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmationCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const ConfirmationCheckbox(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: <Widget>[
        Checkbox(
          value: value,
          onChanged: onChanged,
          checkColor: const Color.fromARGB(255, 77, 77, 77),
          activeColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        Expanded(
          child: Text(
            'I am sure this is the correct answer',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: screenWidth * 0.045,
            ),
          ),
        ),
      ],
    );
  }
}
