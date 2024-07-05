import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import 'package:sahai/screens/chat/guest_chat_screen.dart';
import 'package:sahai/screens/chat/text_chat_screen.dart';

import 'package:provider/provider.dart';
import 'package:sahai/providers/user_provider.dart';

import 'package:sahai/models/user_model.dart';

Widget CustomCard(
  BuildContext context,
  String headingText,
  String subheadingText1,
  String buttonText1,
  String buttonText2,
  bool isFirstPage,
  double progress,
  Function? navigateToLoginPage,
) {
  Color color1 = Color(0xffF37C00);
  Color color2 = Color(0xffACACAC);
  double screenwidth = MediaQuery.of(context).size.width;
  double screenheight = MediaQuery.of(context).size.height;

  Future<void> handleSignIn(String userType) async {
    final AuthService _authService = AuthService();
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );
      UserCredential? userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        String? email = userCredential.user?.email;
        if (email != null) {
          UserModel user = UserModel(
            uid: userCredential.user!.uid,
            email: email,
            userType: email.endsWith('@pesu.pes.edu') ? 'pesu' : 'guest',
          );
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          if (user.userType == 'pesu') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TextChatScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please sign-in with your university email')));
          }
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed. Please try again.')));
    }
  }

  return Card(
    elevation: 3,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.78),
    ),
    child: Container(
      width: screenwidth,
      height: screenheight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  width: screenwidth * 0.4,
                  height: screenheight * 0.008,
                  decoration: BoxDecoration(
                    color: color1,
                    borderRadius: BorderRadius.circular(80.78),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 20),
                child: Container(
                  width: screenwidth * 0.4,
                  height: screenheight * 0.008,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color1, color2],
                      stops: [progress, progress],
                    ),
                    borderRadius: BorderRadius.circular(80.78),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenheight * 0.02),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              headingText,
              style: GoogleFonts.inter(
                fontSize: screenwidth * 0.055,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 20, top: 3),
            child: Text(
              subheadingText1,
              style: GoogleFonts.vazirmatn(
                fontSize: screenwidth * 0.04,
                fontWeight: FontWeight.w400,
                color: Color(0xff545454),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 20),
            child: isFirstPage
                ? Text('')
                : RichText(
                    text: TextSpan(
                        text: 'or continue as ',
                        style: GoogleFonts.vazirmatn(
                          fontSize: screenwidth * 0.04,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff545454),
                        ),
                        children: [
                          TextSpan(
                            text: 'Guest',
                            style: GoogleFonts.vazirmatn(
                              fontSize: screenwidth * 0.042,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff545454),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GuestChat())),
                          )
                        ]),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 20, top: 3),
            child: ElevatedButton(
              onPressed: () {
                if (isFirstPage) {
                  navigateToLoginPage?.call();
                } else {
                  handleSignIn('student');
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 2,
                backgroundColor: color1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.78),
                ),
                minimumSize: Size(screenwidth * 0.95, screenheight * 0.05),
              ),
              child: isFirstPage
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          buttonText1,
                          style: GoogleFonts.inter(
                            fontSize: screenwidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    )
                  : Center(
                      child: Text(
                        buttonText1,
                        style: GoogleFonts.inter(
                          fontSize: screenwidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: screenheight * 0.015),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 20, top: 3),
            child: ElevatedButton(
              onPressed: () {
                if (isFirstPage) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GuestChat()));
                } else {
                  handleSignIn('staff');
                }
              },
              child: Text(
                buttonText2,
                style: GoogleFonts.inter(
                  fontSize: screenwidth * 0.04,
                  fontWeight: isFirstPage ? FontWeight.w400 : FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff4D4D4D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.78),
                ),
                minimumSize: Size(screenwidth * 0.95, screenheight * 0.05),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
