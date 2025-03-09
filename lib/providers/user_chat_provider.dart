import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahai/models/message_model.dart';
import 'package:sahai/providers/base_chat_provider.dart';

class ChatProvider with ChangeNotifier, BaseChatProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _lastMessageTime = DateTime.now();

  Future<void> fetchMessages(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .orderBy('deliveryTime', descending: true)
          .get();

      messageList.clear(); // Use protected getter
      for (var doc in snapshot.docs) {
        final deliveryTime = (doc['deliveryTime'] as Timestamp).toDate();

        // Use addMessage() for proper sorting/notification
        addMessage(MessageModel(
          message: doc['message'],
          isUser: true,
          timestamp: deliveryTime,
        ));

        addMessage(MessageModel(
          message: doc['response'],
          isUser: false,
          timestamp: deliveryTime, // No +1ms needed
        ));
      }
    } catch (e) {
      setError('Failed to load history: ${e.toString()}');
    }
  }

  Future<void> sendMessage(String userId, String message) async {
    try {
      if (DateTime.now().difference(_lastMessageTime) < Duration(seconds: 1))
        return;
      _lastMessageTime = DateTime.now();

      final trimmed = message.trim();
      if (trimmed.isEmpty) return;

      addMessage(MessageModel(
          message: trimmed, isUser: true, timestamp: DateTime.now()));

      String response = await generateResponse(trimmed);

      addMessage(MessageModel(
          message: response, isUser: false, timestamp: DateTime.now()));

      await _storeInFirestore(userId, trimmed, response, DateTime.now());
    } catch (e) {
      setError('Failed to send message: ${e.toString()}');
    }
  }

  Future<String> generateResponse(String message) async {
    // This is a dummy function. Replace with actual API call later.
    await Future.delayed(const Duration(seconds: 1));
    return 'Mock response to: $message';
  }

  Future<void> _storeInFirestore(String userId, String message, String response,
      DateTime timeStamp) async {
    final data = {
      'message': message,
      'response': response,
      'deliveryTime': timeStamp,
    };
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .add(data);
  }
}
