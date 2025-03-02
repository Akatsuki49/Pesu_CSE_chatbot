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
  Color color1 = const Color(0xffF37C00);
  Color color2 = const Color(0xffACACAC);
  double screenwidth = MediaQuery.of(context).size.width;
  double screenheight = MediaQuery.of(context).size.height;
  Future<void> handleSignIn(String userType) async {
    final AuthService authService = AuthService();
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      UserCredential? userCredential = await authService.signInWithGoogle();

      // Hide loading indicator
      Navigator.of(context).pop();

      if (userCredential != null) {
        String? email = userCredential.user?.email;
        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          email: email ?? '', // Use empty string as default when null
          userType: (email != null && email.endsWith('@pesu.pes.edu'))
              ? 'pesu'
              : 'guest',
        );
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        if (user.userType == 'pesu') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const TextChatScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please sign-in with your university email')));
        }
      } else {
        // User cancelled the sign-in process
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-in was cancelled')));
      }
    } catch (e) {
      // Hide loading indicator in case of error
      Navigator.of(context).pop();

      print('Error signing in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-in failed. Please try again.')));
    }
  }

  // Future<void> handleSignIn(String userType) async {
  //   final AuthService authService = AuthService();
  //   try {
  //     // Show loading indicator
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return const Center(child: CircularProgressIndicator());
  //       },
  //     );
  //     UserCredential? userCredential = await authService.signInWithGoogle();

  //     if (userCredential != null) {
  //       String? email = userCredential.user?.email;
  //       if (email != null) {
  //         UserModel user = UserModel(
  //           uid: userCredential.user!.uid,
  //           email: email,
  //           userType: email.endsWith('@pesu.pes.edu') ? 'pesu' : 'guest',
  //         );
  //         Provider.of<UserProvider>(context, listen: false).setUser(user);

  //         if (user.userType == 'pesu') {
  //           Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => const TextChatScreen()));
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //               content: Text('Please sign-in with your university email')));
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error signing in with Google: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Sign-in failed. Please try again.')));
  //   }
  // }

  return Card(
    elevation: 3,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(screenwidth * 0.085),
        topRight: Radius.circular(screenwidth * 0.085),
      ),
    ),
    child: SizedBox(
      width: screenwidth,
      height: screenheight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenheight * 0.02),
                child: Container(
                  width: screenwidth * 0.4,
                  height: screenheight * 0.008,
                  decoration: BoxDecoration(
                    color: color1,
                    borderRadius: BorderRadius.circular(screenwidth * 0.15),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenwidth * 0.02, top: screenheight * 0.02),
                child: Container(
                  width: screenwidth * 0.4,
                  height: screenheight * 0.008,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color1, color2],
                      stops: [progress, progress],
                    ),
                    borderRadius: BorderRadius.circular(screenwidth * 0.15),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenheight * 0.02),
          Padding(
            padding: EdgeInsets.only(left: screenwidth * 0.067),
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
            padding: EdgeInsets.only(
                left: screenwidth * 0.067, top: screenheight * 0.01),
            child: Text(
              subheadingText1,
              style: GoogleFonts.vazirmatn(
                fontSize: screenwidth * 0.04,
                fontWeight: FontWeight.w400,
                color: const Color(0xff545454),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenwidth * 0.067),
            child: isFirstPage
                ? const Text('')
                : RichText(
                    text: TextSpan(
                        text: 'or continue as ',
                        style: GoogleFonts.vazirmatn(
                          fontSize: screenwidth * 0.04,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff545454),
                        ),
                        children: [
                          TextSpan(
                            text: 'Guest',
                            style: GoogleFonts.vazirmatn(
                              fontSize: screenwidth * 0.042,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff545454),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GuestChatScreen())),
                          )
                        ]),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: screenwidth * 0.067,
                top: screenheight * 0.01,
                right: screenwidth * 0.067),
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
                  borderRadius: BorderRadius.circular(screenwidth * 0.085),
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
                        const Icon(Icons.arrow_forward, color: Colors.white),
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
            padding: EdgeInsets.only(
                left: screenwidth * 0.067,
                top: screenheight * 0.01,
                right: screenwidth * 0.067),
            child: ElevatedButton(
              onPressed: () {
                if (isFirstPage) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GuestChatScreen()));
                } else {
                  handleSignIn('staff');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4D4D4D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenwidth * 0.085),
                ),
                minimumSize: Size(screenwidth * 0.95, screenheight * 0.05),
              ),
              child: Text(
                buttonText2,
                style: GoogleFonts.inter(
                  fontSize: screenwidth * 0.04,
                  fontWeight: isFirstPage ? FontWeight.w400 : FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
