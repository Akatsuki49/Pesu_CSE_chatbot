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
/*************  ✨ Codeium Command ⭐  *************/
  /// Builds the landing page with Pesu logo, tagline, and a button to navigate to the login page.
  ///
  /// The page is built with a Pesu logo at the top, followed by a tagline and a subtitle.
  /// Below that, there is a button to navigate to the login page.
  /// The button is wrapped in an [Expanded] widget to ensure it takes up the entire height of the screen.
  /// The button is also wrapped in an [Align] widget to center it at the bottom of the screen.
  /// The button itself is a [CustomCard] widget, which is a custom widget to display a card with a title, subtitle, and two buttons.
  /// The progress value is currently set to 0.0, which is a dummy value for the first page.
/// ****  4ec710a3-3f8d-464a-bccc-dbadc26d09a0  ******
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff00377A),
      appBar: AppBar(
        backgroundColor: const Color(0xff00377A),
        leadingWidth: screenwidth * 0.38,
        leading: Padding(
          padding: EdgeInsets.only(top: screenheight * 0.01),
          child: Image.asset(
            'assets/images/pesu_white_logo.png',
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
            padding: EdgeInsets.only(left: screenwidth * 0.052),
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
            padding: EdgeInsets.only(left: screenwidth * 0.052),
            child: SizedBox(
              width: screenwidth * 0.75,
              child: Text(
                'a student-led initiative to make your experience smoother at the Deptartment of CSE',
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
              child: CustomCard(
                context,
                'Welcome to sah.ai! 👋🏻',
                'Your ultimate guide to navigating anything at PESU CSE and studying with ease!',
                'Get Started',
                'Proceed as Guest',
                true,
                progress,
                _navigateToLoginPage,
              ), //true for first page and false for second page
            ),
          )
        ],
      ),
    );
  }
}
