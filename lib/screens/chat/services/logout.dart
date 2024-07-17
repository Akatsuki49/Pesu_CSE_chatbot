import 'package:flutter/material.dart';

Future<void> _handleLogout() async {
  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(child: CircularProgressIndicator());
    },
  );

  try {
    await AuthService().signOut();
    Provider.of<UserProvider>(context, listen: false).clearUser();

    // Hide loading indicator
    Navigator.of(context).pop();

    // Pop until we reach the LandingPage
    Navigator.of(context).popUntil((route) => route.isFirst);
  } catch (e) {
    // Hide loading indicator
    Navigator.of(context).pop();

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout failed. Please try again.')),
    );
  }
}
