import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import 'package:sahai/screens/auth/landing_page.dart';
import 'package:sahai/screens/chat/text_chat_screen.dart';
import 'package:sahai/screens/chat/guest_chat_screen.dart';
import 'package:sahai/models/user_model.dart';
import 'package:sahai/screens/disclaimer_screen.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/animation.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });

    _controller.setLooping(false);
    _controller.addListener(_checkVideoEnd);
  }

  void _checkVideoEnd() {
    if (_controller.value.position == _controller.value.duration) {
      _navigateToNextScreen();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    AuthService authService = AuthService();
    UserModel? user = authService.getCurrentUser();

    Widget nextScreen = user != null
        ? (user.userType == 'pesu' ? DisclaimerScreen() : const GuestChat())
        : const LandingPage();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeIn;

          var tween = Tween<double>(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var opacityAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
        transitionDuration:
            const Duration(milliseconds: 800), // Increased duration
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(), // Empty container while video is loading
      ),
    );
  }
}
