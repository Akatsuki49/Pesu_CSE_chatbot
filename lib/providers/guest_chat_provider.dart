import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahai/models/message_model.dart';
import 'package:sahai/providers/base_chat_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestChatProvider with ChangeNotifier, BaseChatProvider {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sendMessage(String message) async {
    try {
      final trimmed = message.trim();
      if (trimmed.isEmpty) return;

      // USE BASE METHOD:
      addMessage(MessageModel(
          message: trimmed,
          isUser: true,
          timestamp: DateTime.now() // ✅ FIXED TIMESTAMP
          ));

      String response = await generateResponse(trimmed);

      addMessage(MessageModel(
          message: response,
          isUser: false,
          timestamp: DateTime.now() // ✅ FIXED TIMESTAMP
          ));
    } catch (e) {
      setError('Failed to send message: ${e.toString()}');
    }
  }

  Future<String> generateResponse(String message) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Mock response to: $message';
  }

  // ADD AT BOTTOM OF FILE:
  @override
  void dispose() {
    _cacheMessages();
    super.dispose();
  }

  void _cacheMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'guest_messages',
        messageList // ✅ Use protected getter
            .map((msg) => jsonEncode({
                  'message': msg.message,
                  'isUser': msg.isUser,
                  'timestamp': msg.timestamp.toIso8601String(),
                }))
            .toList());
  }

  Future<void> loadCachedMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getStringList('guest_messages') ?? [];
    messageList.addAll(cached.map((json) => MessageModel(
          message: jsonDecode(json)['message'],
          isUser: jsonDecode(json)['isUser'],
          timestamp: DateTime.parse(jsonDecode(json)['timestamp']),
        )));
    notifyListeners();
  }
}
