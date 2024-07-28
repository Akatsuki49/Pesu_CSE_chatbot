import 'package:flutter/material.dart';

class FabBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context); // Navigate to the previous screen
      },
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }
}
