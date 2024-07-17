// lib/screens/chat/text_chat_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/models/message_model.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/screens/auth/landing_page.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import './widgets/message_bubble.dart';
import './widgets/chat_input.dart';

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key});

  @override
  _TextChatScreenState createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final List<MessageModel> _messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _handleSubmitted(String text) {
    setState(() {
      _messages.add(MessageModel(message: text, isUser: true));
    });

    String resp = generateMockResponse();
    storeInFirestore(text, resp);
  }

  String generateMockResponse() {
    String resp = 'Mock Response From Bot';
    setState(() {
      _messages.add(MessageModel(message: resp, isUser: false));
    });

    return resp;
  }

  Future<void> storeInFirestore(String text, String resp) async {
    final userID = Provider.of<UserProvider>(context, listen: false).user?.uid;
    final timeStamp = DateTime.now();

    final data = {
      'message': text,
      'response': resp,
      'deliveryTime': timeStamp,
    };
    await _firestore
        .collection('users')
        .doc(userID)
        .collection('chats')
        .add(data);
  }

  Future<void> _fetchMessages() async {
    //get user id from same device must have the sameID: else there will be probs:
    final userID = Provider.of<UserProvider>(context, listen: false).user?.uid;
    final snapshot = await _firestore
        .collection('users')
        .doc(userID)
        .collection('chats')
        .get();

    setState(() {
      _messages.clear();
      _messages.add(MessageModel(
          message: 'Hello! How may I assist you today?', isUser: false));
      for (var doc in snapshot.docs) {
        _messages.add(MessageModel(message: doc['message'], isUser: true));
        _messages.add(MessageModel(message: doc['response'], isUser: false));
      }
    });
  }

  Future<void> _handleLogout() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await AuthService().signOut();
      Provider.of<UserProvider>(context, listen: false).clearUser();

      // Hide loading indicator
      Navigator.of(context).pop();

      // Pop until we reach the LandingPage
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ));
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    _fetchMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: screenwidth * 0.38,
          leading: Image.asset(
            'assets/images/pesu_logo_png.png',
            width: screenwidth * 0.3,
            height: screenwidth * 0.3,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _handleLogout,
            ),
            Padding(
              padding: EdgeInsets.only(right: screenwidth * 0.03),
              child: Image.asset('assets/images/sah.ai_greyText.png'),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final messageModel = _messages[_messages.length - 1 - index];
                  return MessageBubble(
                    message: messageModel.message,
                    isMe: messageModel.isUser,
                  );
                },
              ),
            ),
            ChatInput(onSubmitted: _handleSubmitted),
          ],
        ),
      ),
    );
  }
}
