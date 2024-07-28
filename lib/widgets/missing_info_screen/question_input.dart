import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionInput extends StatelessWidget {
  final TextEditingController controller;

  const QuestionInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter your question here',
        hintStyle: GoogleFonts.lato(
          color: Colors.white54,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white54,
            width: 3.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 3.0,
          ),
        ),
      ),
      style: GoogleFonts.lato(
        color: Colors.white,
      ),
      maxLines: 1,
      textInputAction: TextInputAction.next,
    );
  }
}
