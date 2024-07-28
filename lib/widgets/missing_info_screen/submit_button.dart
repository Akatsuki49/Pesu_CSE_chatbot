import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: () {
        // haptic feedback
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Text('Submit'),
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 65, 65, 65),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenWidth * 0.04,
        ),
      ),
    );
  }
}
