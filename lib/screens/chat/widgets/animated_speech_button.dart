import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedSpeechButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;

  const AnimatedSpeechButton(
      {super.key, required this.isListening, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          child: Lottie.asset(
            'assets/images/lottie1.json',
            repeat: true,
            animate: isListening,
          ),
        ),
      ),
    );
  }
}
