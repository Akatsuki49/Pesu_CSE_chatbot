import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/guest_chat_provider.dart';
import 'package:sahai/screens/auth/login_page.dart';
import 'package:sahai/screens/chat/widgets/chat_input.dart';
import 'package:sahai/screens/chat/widgets/message_bubble.dart';
import 'package:sahai/screens/auth/landing_page.dart';

class GuestChatScreen extends StatefulWidget {
  const GuestChatScreen({super.key});

  @override
  _GuestChatScreenState createState() => _GuestChatScreenState();
}

class _GuestChatScreenState extends State<GuestChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSubmitted(String text) {
    final chatProvider = Provider.of<GuestChatProvider>(context, listen: false);

    // Add user message
    chatProvider.addUserMessage(text);

    // Scroll after user message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToBottom();
      }
    });

    // Add bot response after a delay
    chatProvider.addBotResponse(text).then((_) {
      // Scroll again after bot response is added
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
            SizedBox(width: screenWidth * 0.1),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xff00377A),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<GuestChatProvider>(
              builder: (context, provider, _) {
                if (provider.errorMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.errorMessage!)));
                    provider.clearError();
                  });
                }
                return ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return MessageBubble(
                      message: message.message,
                      isMe: message.isUser,
                      timestamp: message.timestamp,
                    );
                  },
                );
              },
            ),
          ),
          ChatInput(onSubmitted: _handleSubmitted),
        ],
      ),
    );
  }
}
