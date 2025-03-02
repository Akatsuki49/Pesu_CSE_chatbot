import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import 'package:sahai/screens/auth/landing_page.dart';
import 'package:sahai/screens/chat/text_chat_screen.dart';
import 'package:sahai/screens/chat/guest_chat_screen.dart';
import 'package:sahai/models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserSessionAndNavigate();
  }

  Future<void> _checkUserSessionAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUser();

    if (userProvider.user != null) {
      print("Waiting");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => userProvider.user!.userType == 'pesu'
            ? const TextChatScreen()
            : const GuestChatScreen(),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/pesu_logo_png.png'),
      ),
    );
  }
}
