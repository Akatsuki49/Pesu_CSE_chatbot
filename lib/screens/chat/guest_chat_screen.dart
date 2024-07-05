import 'package:flutter/material.dart';
import 'package:sahai/screens/auth/landing_page.dart'; // Import your landing page

class GuestChat extends StatelessWidget {
  const GuestChat({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Guest Chat'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Guest Chat Screen'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the login screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LandingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
