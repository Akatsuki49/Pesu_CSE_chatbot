import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sahai/screens/chat/text_chat_screen.dart';
import 'package:sahai/screens/chat/widgets/disclaimer_info_row.dart';
import 'dart:async';

class DisclaimerScreen extends StatefulWidget {
  @override
  _DisclaimerScreenState createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _isEnglish = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      setState(() {
        _isEnglish = !_isEnglish;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          right: screenwidth * 0.08,
          left: screenwidth * 0.08,
          top: screenwidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenheight * 0.05),
            Image.asset(
              'assets/images/pesu_logo_png.png', // Ensure this path is correct
              width: screenwidth * 0.3,
            ),
            SizedBox(height: screenheight * 0.04),
            SizedBox(
              height: screenheight * 0.18, // Adjusted to fit text comfortably
              child: AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: Text(
                  _isEnglish ? 'Welcome to sah.ai!' : 'ಸಹ.ಎಐ ಗೆ ಸ್ವಾಗತ!',
                  key: ValueKey<bool>(_isEnglish),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff00377A),
                    fontFamily: 'Inter',
                    fontSize: screenwidth * 0.12,
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenheight * 0.08),
            Padding(
              padding: EdgeInsets.only(right: screenwidth * 0.08),
              child: AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: Column(
                  key: ValueKey<bool>(_isEnglish),
                  children: [
                    SizedBox(
                      height: screenheight * 0.10, // Adjusted height
                      child: DisclaimerInfoRow(
                        icon: Icons.info,
                        text: _isEnglish
                            ? 'Your conversation may be sent to human reviewers for internal improvement purposes.'
                            : 'ನಿಮ್ಮ ಮಾತುಕತೆ ಆಂತರಿಕ ಸುಧಾರಣಾ ಉದ್ದೇಶಗಳಿಗಾಗಿ ಮಾನವ ವಿಮರ್ಶಕರಿಗೆ ಕಳುಹಿಸಲಾಗಬಹುದು.',
                      ),
                    ),
                    SizedBox(height: screenheight * 0.015),
                    SizedBox(
                      height: screenheight * 0.10, // Adjusted height
                      child: DisclaimerInfoRow(
                        icon: Icons.lock,
                        text: _isEnglish
                            ? 'Sensitive information can only be accessed by authorized users.'
                            : 'ಸಂಪೂರ್ಣ ಮಾಹಿತಿಯನ್ನು ಕೇವಲ ಅಧಿಕಾರ ಪಡೆದ ಬಳಕೆದಾರರು ಮಾತ್ರ ಪ್ರವೇಶಿಸಬಹುದು.',
                      ),
                    ),
                    SizedBox(height: screenheight * 0.01),
                    SizedBox(
                      height: screenheight * 0.10, // Adjusted height
                      child: DisclaimerInfoRow(
                        icon: Icons.contact_support,
                        text: _isEnglish
                            ? 'In case of incorrect/outdated information contact department office.'
                            : 'ತಪ್ಪಾದ/ಹಳೆಯ ಮಾಹಿತಿಯು ಕಂಡುಬಂದಲ್ಲಿ ಇಲಾಖೆ ಕಚೇರಿಯನ್ನು ಸಂಪರ್ಕಿಸಿ.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const TextChatScreen(),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      'assets/images/button_animation.json',
                      width: screenwidth * 0.8,
                      height: 80, // Adjust the height to fit the animation
                    ),
                    AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: Text(
                        _isEnglish
                            ? 'I Understand'
                            : 'ನಾನು ಅರ್ಥಮಾಡಿಕೊಂಡಿದ್ದೇನೆ',
                        key: ValueKey<bool>(_isEnglish),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenwidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenheight * 0.05), // Adjust the bottom padding
          ],
        ),
      ),
    );
  }
}
