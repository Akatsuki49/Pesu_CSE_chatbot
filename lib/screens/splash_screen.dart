// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sahai/providers/user_provider.dart';
// import 'package:sahai/screens/auth/services/auth_service.dart';
// import 'package:sahai/screens/auth/landing_page.dart';
// import 'package:sahai/screens/chat/text_chat_screen.dart';
// import 'package:sahai/screens/chat/guest_chat_screen.dart';
// import 'package:sahai/models/user_model.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkUserSessionAndNavigate();
//   }

//   Future<void> _checkUserSessionAndNavigate() async {
//     await Future.delayed(const Duration(seconds: 3));

//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     await userProvider.loadUser();

//     if (userProvider.user != null) {
//       print("Waiting");
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => userProvider.user!.userType == 'pesu'
//             ? const TextChatScreen()
//             : const GuestChatScreen(),
//       ));
//     } else {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const LandingPage(),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Image.asset('assets/images/pesu_logo_png.png'),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sahai/providers/user_provider.dart';
// import 'package:sahai/screens/auth/landing_page.dart';
// import 'package:sahai/screens/chat/text_chat_screen.dart';
// import 'package:sahai/screens/chat/guest_chat_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Setup animation
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _fadeAnimation =
//         Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
//     _animationController.forward();

//     // Navigate after delay
//     _checkUserSessionAndNavigate();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _checkUserSessionAndNavigate() async {
//     await Future.delayed(const Duration(seconds: 1));

//     try {
//       if (!mounted) return;

//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       await userProvider.loadUser();

//       if (!mounted) return;

//       // Navigate based on user status
//       if (userProvider.user != null) {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => userProvider.user!.userType == 'pesu'
//               ? const TextChatScreen()
//               : const GuestChatScreen(),
//         ));
//       } else {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const LandingPage(),
//         ));
//       }
//     } catch (e) {
//       // If there's an error, still navigate to landing page
//       if (mounted) {
//         debugPrint('Error in splash screen: $e');
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const LandingPage(),
//         ));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/pesu_logo_png.png',
//                 width: 200,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Icon(Icons.school,
//                       size: 120, color: Colors.grey);
//                 },
//               ),
//               const SizedBox(height: 30),
//               const CircularProgressIndicator(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/screens/auth/landing_page.dart';
import 'package:sahai/screens/chat/text_chat_screen.dart';
import 'package:sahai/screens/chat/guest_chat_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    // Navigate after delay
    _checkUserSessionAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkUserSessionAndNavigate() async {
    // Keep the 3 second delay since you mentioned it's working
    await Future.delayed(const Duration(seconds: 3));

    // Use a try-catch to handle potential errors gracefully
    try {
      if (!mounted) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUser();

      if (!mounted) return;

      // Navigate based on user status
      if (userProvider.user != null) {
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
    } catch (e) {
      // If there's an error, still navigate to landing page
      if (mounted) {
        debugPrint('Error in splash screen: $e');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LandingPage(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/pesu_logo_png.png',
                width: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.school,
                      size: 120, color: Colors.grey);
                },
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
