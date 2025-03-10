// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sahai/providers/user_provider.dart';
// import 'package:sahai/providers/user_chat_provider.dart';
// import 'package:sahai/screens/auth/landing_page.dart';
// import 'package:sahai/screens/auth/services/auth_service.dart';
// import 'package:sahai/screens/chat/widgets/chat_input.dart';
// import 'package:sahai/screens/chat/widgets/message_bubble.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TextChatScreen extends StatefulWidget {
//   const TextChatScreen({super.key});

//   @override
//   _TextChatScreenState createState() => _TextChatScreenState();
// }

// class _TextChatScreenState extends State<TextChatScreen> {
//   final AuthService _authService = AuthService();
//   late String? _userId;
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoadingMore = false;
//   bool _initialScrollComplete = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupScrollController();

//     // Using Future.microtask ensures this code runs after the current build cycle
//     Future.microtask(() {
//       if (mounted) {
//         _userId = Provider.of<UserProvider>(context, listen: false).user?.uid;
//         if (_userId != null) {
//           Provider.of<ChatProvider>(context, listen: false)
//               .fetchMessages(_userId!)
//               .then((_) {
//             _scrollToBottomWithDelay();
//           });
//         }
//       }
//     });
//   }

//   void _setupScrollController() {
//     _scrollController.addListener(() {
//       // When we reach the top of the list and there are more messages to load
//       if (_scrollController.position.pixels <= 0 &&
//           !_isLoadingMore &&
//           Provider.of<ChatProvider>(context, listen: false).hasMoreMessages) {
//         _loadMoreMessages();
//       }
//     });
//   }

//   // Adding a slight delay ensures the scroll happens after layout is complete
//   void _scrollToBottomWithDelay() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (mounted && !_initialScrollComplete) {
//         _scrollToBottom();
//         _initialScrollComplete = true;
//       }
//     });
//   }

//   Future<void> _loadMoreMessages() async {
//     if (_userId == null) return;

//     setState(() {
//       _isLoadingMore = true;
//     });

//     // Save current position
//     final previousPosition = _scrollController.position.pixels;
//     final previousMaxExtent = _scrollController.position.maxScrollExtent;

//     await Provider.of<ChatProvider>(context, listen: false)
//         .loadMoreMessages(_userId!);

//     // After loading more messages, restore scroll position
//     if (mounted) {
//       setState(() {
//         _isLoadingMore = false;
//       });

//       // Wait for layout to complete then adjust scroll position
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients) {
//           final newMaxExtent = _scrollController.position.maxScrollExtent;
//           final delta = newMaxExtent - previousMaxExtent;
//           _scrollController.jumpTo(previousPosition + delta);
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   Future<void> _handleSubmitted(String text) async {
//     if (text.trim().isEmpty || _userId == null) return;

//     final chatProvider = Provider.of<ChatProvider>(context, listen: false);

//     // Add user message
//     await chatProvider.addUserMessage(_userId!, text);

//     // Scroll after user message is added
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         _scrollToBottom();
//       }
//     });

//     // Get bot response
//     await chatProvider.addBotResponse(_userId!, text);

//     // Scroll again after bot response is added
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         _scrollToBottom();
//       }
//     });
//   }

//   Future<void> _handleLogout() async {
//     print("Attempting to log out...");

//     await _authService.signOut();
//     print("Signed out successfully.");

//     // Clear user info and messages
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     await userProvider.clearUser(); // Clear user data

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     print("Preferences cleared!");

//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => const LandingPage()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           scrolledUnderElevation: 0,
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           toolbarHeight: 80,
//           leadingWidth: screenWidth,
//           leading: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   'assets/images/pesu_logo_png.png',
//                   height: 100,
//                   width: 100,
//                 ),
//               ),
//               SizedBox(width: screenWidth * 0.27),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   'assets/images/sah.ai_greyText.png',
//                   height: 80,
//                   width: 80,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             IconButton(
//                 icon: Icon(Icons.logout),
//                 onPressed: () async {
//                   final confirmed = await showDialog<bool>(
//                     context: context,
//                     builder: (ctx) => AlertDialog(
//                       title: Text(
//                         'Confirm Logout?',
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(ctx, false),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               // color: Colors.red[300],
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Text('Cancel',
//                                   style: TextStyle(color: Colors.black)),
//                             ),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.pop(ctx, true),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: const Color(0xff00377A),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Text('Logout',
//                                   style: TextStyle(color: Colors.white)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                   if (confirmed ?? false) _handleLogout();
//                 }),
//           ],
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: Consumer<ChatProvider>(
//                 builder: (context, provider, _) {
//                   if (provider.errorMessage != null) {
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(provider.errorMessage!)));
//                       provider.clearError();
//                     });
//                   }

//                   if (provider.messages.isEmpty) {
//                     return Center(
//                       child: Text(
//                         "No messages yet. Start a conversation!",
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 16,
//                         ),
//                       ),
//                     );
//                   }

//                   return Stack(
//                     children: [
//                       // Loading indicator at the top
//                       if (_isLoadingMore)
//                         Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           child: LinearProgressIndicator(),
//                         ),

//                       // Message list
//                       ListView.builder(
//                         controller: _scrollController,
//                         reverse: false, // Keep false to show oldest at top
//                         itemCount: provider.messages.length,
//                         itemBuilder: (context, index) {
//                           final message = provider.messages[index];
//                           return MessageBubble(
//                             message: message.message,
//                             isMe: message.isUser,
//                             timestamp: message.timestamp,
//                           );
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             ChatInput(onSubmitted: _handleSubmitted),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahai/providers/user_provider.dart';
import 'package:sahai/providers/user_chat_provider.dart';
import 'package:sahai/screens/auth/landing_page.dart';
import 'package:sahai/screens/auth/services/auth_service.dart';
import 'package:sahai/screens/chat/widgets/chat_input.dart';
import 'package:sahai/screens/chat/widgets/date_header.dart';
import 'package:sahai/screens/chat/widgets/message_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key});

  @override
  _TextChatScreenState createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final AuthService _authService = AuthService();
  late String? _userId;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _initialScrollComplete = false;

  @override
  void initState() {
    super.initState();
    _setupScrollController();

    // Using Future.microtask ensures this code runs after the current build cycle
    Future.microtask(() {
      if (mounted) {
        _userId = Provider.of<UserProvider>(context, listen: false).user?.uid;
        if (_userId != null) {
          Provider.of<ChatProvider>(context, listen: false)
              .fetchMessages(_userId!)
              .then((_) {
            _scrollToBottomWithDelay();
          });
        }
      }
    });
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      // When we reach the top of the list and there are more messages to load
      if (_scrollController.position.pixels <= 0 &&
          !_isLoadingMore &&
          Provider.of<ChatProvider>(context, listen: false).hasMoreMessages) {
        _loadMoreMessages();
      }
    });
  }

  // Adding a slight delay ensures the scroll happens after layout is complete
  void _scrollToBottomWithDelay() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !_initialScrollComplete) {
        _scrollToBottom();
        _initialScrollComplete = true;
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    if (_userId == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Save current position
    final previousPosition = _scrollController.position.pixels;
    final previousMaxExtent = _scrollController.position.maxScrollExtent;

    await Provider.of<ChatProvider>(context, listen: false)
        .loadMoreMessages(_userId!);

    // After loading more messages, restore scroll position
    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });

      // Wait for layout to complete then adjust scroll position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final newMaxExtent = _scrollController.position.maxScrollExtent;
          final delta = newMaxExtent - previousMaxExtent;
          _scrollController.jumpTo(previousPosition + delta);
        }
      });
    }
  }

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

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _userId == null) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // Add user message
    await chatProvider.addUserMessage(_userId!, text);

    // Scroll after user message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToBottom();
      }
    });

    // Get bot response
    await chatProvider.addBotResponse(_userId!, text);

    // Scroll again after bot response is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToBottom();
      }
    });
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
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        'Confirm Logout?',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Cancel',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xff00377A),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Logout',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirmed ?? false) _handleLogout();
                }),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, _) {
                  if (provider.errorMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(provider.errorMessage!)));
                      provider.clearError();
                    });
                  }

                  // Show loading indicator during initial fetch instead of "No messages"
                  if (provider.isInitialFetch) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.messages.isEmpty) {
                    return Center(
                      child: Text(
                        "No messages yet. Start a conversation!",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  // Group messages by date
                  final Map<String, List<int>> messagesByDate = {};
                  for (int i = 0; i < provider.messages.length; i++) {
                    final message = provider.messages[i];
                    final date =
                        DateFormat('yyyy-MM-dd').format(message.timestamp);
                    messagesByDate.putIfAbsent(date, () => []);
                    messagesByDate[date]!.add(i);
                  }

                  // Get sorted dates
                  final sortedDates = messagesByDate.keys.toList()
                    ..sort((a, b) => a.compareTo(b));

                  return Stack(
                    children: [
                      // Loading indicator at the top
                      if (_isLoadingMore)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(),
                        ),

                      // Message list
                      ListView.builder(
                        controller: _scrollController,
                        reverse: false, // Keep false to show oldest at top
                        itemCount:
                            provider.messages.length + sortedDates.length,
                        itemBuilder: (context, index) {
                          // Calculate which date section we're in
                          int messageIndex = index;
                          String? currentDate;

                          for (String date in sortedDates) {
                            if (messageIndex == 0) {
                              // This is a date header
                              currentDate = date;
                              messageIndex--;
                              break;
                            } else if (messageIndex <=
                                messagesByDate[date]!.length) {
                              // This is a message in the current date section
                              final actualIndex =
                                  messagesByDate[date]![messageIndex - 1];
                              return MessageBubble(
                                message: provider.messages[actualIndex].message,
                                isMe: provider.messages[actualIndex].isUser,
                                timestamp:
                                    provider.messages[actualIndex].timestamp,
                              );
                            } else {
                              // Move to next date section
                              messageIndex -= messagesByDate[date]!.length + 1;
                            }
                          }

                          // If we got here, it's a date header
                          if (currentDate != null) {
                            final dateParts = currentDate.split('-');
                            final headerDate = DateTime(
                              int.parse(dateParts[0]),
                              int.parse(dateParts[1]),
                              int.parse(dateParts[2]),
                            );
                            return DateHeader(date: headerDate);
                          }

                          // Fallback (should not happen)
                          return SizedBox();
                        },
                      ),
                    ],
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
