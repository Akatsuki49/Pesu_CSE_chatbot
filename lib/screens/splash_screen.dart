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

    AuthService authService = AuthService();
    UserModel? user = authService.getCurrentUser();

    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            user.userType == 'pesu' ? const TextChatScreen() : const GuestChat(),
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
        child: Image.asset(
            '/Users/shubh/sah.ai/sahai/assets/images/pesu_logo_png.png'),
      ),
    );
  }
}
