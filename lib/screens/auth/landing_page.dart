import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sahai/screens/auth/login_page.dart';
import 'package:sahai/screens/auth/widgets/custom_card.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  double progress = 0.0; //dummy value for first page

  void _navigateToLoginPage() {
    //code to navigate to login page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff00377A),
      appBar: AppBar(
        backgroundColor: const Color(0xff00377A),
        leadingWidth: screenwidth * 0.38,
        leading: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Image.asset(
            '/Users/shubh/sah.ai/sahai/assets/images/pesu_white_logo.png',
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenheight * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Text('sah.ai',
                style: GoogleFonts.inter(
                    fontSize: screenwidth * 0.124,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: screenheight * 0.001,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: SizedBox(
              width: screenwidth * 0.75,
              child: Text(
                'a student-led initiative to make your experience smoother at the Dept. of CSE',
                style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: screenwidth * 0.054,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: screenheight * 0.2,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: CustomCard(
                    context,
                    'Welcome to sah.ai! 👋🏻',
                    'Your ultimate guide to navigating anything at PESU CSE and studying with ease!',
                    'Get Started',
                    'Proceed as Guest',
                    true,
                    progress,
                    _navigateToLoginPage,
                  )), //true for first page and false for second page
            ),
          )
        ],
      ),
    );
  }
}
