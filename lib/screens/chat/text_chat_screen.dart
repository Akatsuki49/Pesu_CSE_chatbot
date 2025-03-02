import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/providers/user_chat_provider.dart';
import 'package:sahai/screens/auth/landing_page.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import 'package:sahai/screens/chat/widgets/chat_input.dart';
import 'package:sahai/screens/chat/widgets/message_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key});

  @override
  _TextChatScreenState createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final AuthService _authService = AuthService();
  late String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = Provider.of<UserProvider>(context, listen: false).user?.uid;
    if (_userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ChatProvider>(context, listen: false)
            .fetchMessages(_userId!);
      });
    }
  }

  Future<void> _handleSubmitted(String text) async {
    if (_userId != null) {
      await Provider.of<ChatProvider>(context, listen: false)
          .sendMessage(_userId!, text);
    }
  }

  Future<void> _handleLogout() async {
    print("Attempting to log out...");

    await _authService.signOut();
    print("Signed out successfully.");

    // Clear user info and messages
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.clearUser(); // Clear user data

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Preferences cleared!");

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          toolbarHeight: 80,
          leadingWidth: screenWidth,
          leading: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/pesu_logo_png.png',
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(width: screenWidth * 0.27),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/sah.ai_greyText.png',
                  height: 80,
                  width: 80,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _handleLogout,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return MessageBubble(
                        message: message.message,
                        isMe: message.isUser,
                      );
                    },
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
