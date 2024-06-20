import 'package:flutter/material.dart';
// have to add a speech-to-text package for audio input
// import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioChatScreen extends StatefulWidget {
  const AudioChatScreen({super.key});

  @override
  _AudioChatScreenState createState() => _AudioChatScreenState();
}

class _AudioChatScreenState extends State<AudioChatScreen> {
  // stt.SpeechToText _speech;
  final bool _isListening = false;
  final String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    // _speech = stt.SpeechToText();
  }

  void _listen() async {
    // Implement speech-to-text functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Chat'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
            _text,
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
