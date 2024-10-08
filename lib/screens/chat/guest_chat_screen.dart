import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/guest_chat_provider.dart';
import 'package:sahai/screens/chat/widgets/chat_input.dart';
import 'package:sahai/screens/chat/widgets/message_bubble.dart';
import 'package:sahai/screens/auth/landing_page.dart';

class GuestChatScreen extends StatelessWidget {
  const GuestChatScreen({Key? key}) : super(key: key);

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<GuestChatProvider>(
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
          ChatInput(
            onSubmitted: (text) =>
                Provider.of<GuestChatProvider>(context, listen: false)
                    .sendMessage(text),
          ),
        ],
      ),
    );
  }
}
