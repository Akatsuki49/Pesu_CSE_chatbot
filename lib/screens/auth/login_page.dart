import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sahai/screens/auth/widgets/custom_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgressAnimation();
  }

  void _startProgressAnimation() {
    const duration = Duration(milliseconds: 20);
    const step = 0.023;

    void updateProgress() {
      if (progress < 1.0) {
        setState(() {
          progress += step;
        });
        Future.delayed(duration, updateProgress);
      }
    }

    updateProgress();
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
                  'Please select one:',
                  'This will help sah.ai fine tune its responses according to your needs',
                  'I’m a student',
                  'I’m a staff',
                  false,
                  progress,
                  null), //true for first page and false for second page
            ),
          )
        ],
      ),
    );
  }
}
