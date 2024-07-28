import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/chat/text_chat_screen.dart';
import '../widgets/missing_info_screen/question_input.dart';
import '../widgets/missing_info_screen/answer_input.dart';
import '../widgets/missing_info_screen/confirmation_checkbox.dart';
import '../widgets/missing_info_screen/submit_button.dart';

import '../widgets/missing_info_screen/success_animation.dart';

class MissingInfoScreen extends StatefulWidget {
  const MissingInfoScreen({super.key});

  @override
  _MissingInfoScreenState createState() => _MissingInfoScreenState();
}

class _MissingInfoScreenState extends State<MissingInfoScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  bool _isSure = false;
  bool _showAnimation = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.1),
                Text(
                  'Question:',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                QuestionInput(controller: _questionController),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Answer (Optional):',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                AnswerInput(controller: _answerController),
                SizedBox(height: screenHeight * 0.03),
                ConfirmationCheckbox(
                  value: _isSure,
                  onChanged: (bool? value) {
                    setState(() {
                      _isSure = value ?? false;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                SubmitButton(
                  onPressed: () {
                    if (_questionController.text.isNotEmpty) {
                      setState(() {
                        _showAnimation = true;
                      });

                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const TextChatScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 0.1);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end);
                              var offsetAnimation = animation
                                  .drive(tween.chain(CurveTween(curve: curve)));

                              return SlideTransition(
                                  position: offsetAnimation, child: child);
                            },
                          ),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a question')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          if (_showAnimation) SuccessAnimation(),
        ],
      ),
      backgroundColor: const Color(0xff00377A),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 59, 59, 59),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
