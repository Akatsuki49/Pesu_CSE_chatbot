import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sahai/models/message_model.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/screens/chat/text_chat_screen.dart'; // Import the TextChatScreen
import 'package:sahai/screens/chat/widgets/response_display.dart';
import 'package:sahai/screens/chat/widgets/animated_speech_button.dart';
import 'package:sahai/screens/chat/widgets/confidence_display.dart';
import 'package:sahai/screens/chat/widgets/fab_back_button.dart';

class AudioChatScreen extends StatefulWidget {
  @override
  _AudioChatScreenState createState() => _AudioChatScreenState();
}

class _AudioChatScreenState extends State<AudioChatScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'bruh': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'shubham': HighlightedWord(
      onTap: () => print('shubham'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'siddhant': HighlightedWord(
      onTap: () => print('siddhant'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'shubh': HighlightedWord(
      onTap: () => print('shubh'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'sowmesh': HighlightedWord(
      onTap: () => print('sowmesh'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _response = '';

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Dismissible(
      key: UniqueKey(), // Required key for Dismissible
      direction: DismissDirection.horizontal, // Enable horizontal swipe
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TextChatScreen()), // Navigate to TextChatScreen
          );
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(112, 18, 18, 18),
        body: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: TextHighlight(
                    text: _text,
                    words: _highlights,
                    textStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: screenWidth * 0.08,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.2,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: ResponseDisplay(response: _response),
            ),
            Positioned(
              bottom: screenHeight * 0.02,
              left: screenWidth * 0.05,
              child: FabBackButton(),
            ),
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.1,
              child: AnimatedSpeechButton(
                isListening: _isListening,
                onTap: _listen,
              ),
            ),
            Positioned(
              top: screenHeight * 0.05,
              left: screenWidth * 0.05,
              child: ConfidenceDisplay(
                confidence: _confidence,
                isListening: _isListening,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == 'listening') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Listening...'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            _handleSubmitted(_text);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _handleSubmitted(String text) {
    setState(() {
      _response = 'Processing...'; // Show a processing message
    });

    _sendToBackend(text).then((resp) {
      setState(() {
        _response = resp; // Display the response from the backend
      });
    });
  }

  Future<String> _sendToBackend(String text) async {
    final userID = Provider.of<UserProvider>(context, listen: false).user?.uid;
    final timeStamp = DateTime.now();

    final data = {
      'message': text,
      'deliveryTime': timeStamp,
    };
    await _firestore
        .collection('users')
        .doc(userID)
        .collection('chats')
        .add(data);

    String resp = 'Response from backend for: $text';

    return resp;
  }
}
