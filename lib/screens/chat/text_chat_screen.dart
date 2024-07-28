import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sahai/models/message_model.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import 'package:sahai/screens/chat/audio_chat_screen.dart';
import 'package:sahai/screens/chat/widgets/message_bubble/message_bubble.dart';
import 'package:sahai/screens/chat/widgets/chat_input.dart';
import 'package:sahai/screens/chat/widgets/custom_drawer.dart';
import '..//chat/widgets/sahai_credits.dart';
import 'package:flutter/services.dart';

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key});

  @override
  _TextChatScreenState createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final List<MessageModel> _messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _tapCounter = 0;

  @override
  void initState() {
    _fetchMessages();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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

      Navigator.of(context).pop();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  Route _createCustomPageRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: screenwidth * 0.03, top: screenheight * 0.00),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.vibrate();
                _tapCounter++;
                if (_tapCounter == 2) {
                  _tapCounter = 0;
                  Navigator.of(context)
                      .push(_createCustomPageRoute(SahaiCredits()));
                }
              },
              child: SizedBox(
                width: screenwidth * 0.18,
                height: screenheight * 0.06,
                child: Image.asset('assets/images/sah.ai_greyText.png'),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu, color: const Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: CustomDrawer(
        onLogout: _handleLogout,
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          HapticFeedback.vibrate();
          if (details.delta.dx > 0) {
            _scaffoldKey.currentState?.openDrawer();
          } else if (details.delta.dx < 0) {
            Navigator.of(context)
                .push(_createCustomPageRoute(AudioChatScreen()));
          }
        },
        child: Column(
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
            ChatInput(
              onSubmitted: _handleSubmitted,
              focusNode: _focusNode,
              inputColor: const Color.fromARGB(255, 18, 18, 18),
              inputBackgroundColor: const Color(0xFFF5F5F5),
            ),
          ],
        ),
      ),
    );
  }
}
