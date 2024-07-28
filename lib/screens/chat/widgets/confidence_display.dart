import 'package:flutter/material.dart';

class ConfidenceDisplay extends StatelessWidget {
  final double confidence;
  final bool isListening;

  const ConfidenceDisplay(
      {super.key, required this.confidence, required this.isListening});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confidence: ${(confidence * 100.0).toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Listening: ${isListening ? 'Yes' : 'No'}',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
