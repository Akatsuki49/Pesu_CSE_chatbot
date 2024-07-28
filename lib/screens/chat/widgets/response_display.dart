import 'package:flutter/material.dart';

class ResponseDisplay extends StatelessWidget {
  final String response;

  const ResponseDisplay({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 33, 33, 33),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        response,
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
