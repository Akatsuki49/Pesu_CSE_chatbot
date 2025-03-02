import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahai/models/message_model.dart';

class ChatProvider with ChangeNotifier {
  final List<MessageModel> _messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<MessageModel> get messages => List.unmodifiable(_messages);

  Future<void> fetchMessages(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .orderBy('deliveryTime', descending: true)
          .get();

      _messages.clear();
      for (var doc in snapshot.docs) {
        _messages.add(MessageModel(
          message: doc['message'],
          isUser: true,
          timestamp: (doc['deliveryTime'] as Timestamp).toDate(),
        ));
        _messages.add(MessageModel(
          message: doc['response'],
          isUser: false,
          timestamp: (doc['deliveryTime'] as Timestamp)
              .toDate()
              .add(Duration(milliseconds: 1)),
        ));
      }
      _sortMessages();
      notifyListeners();
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> sendMessage(String userId, String message) async {
    try {
      final timeStamp = DateTime.now();
      _messages.add(
          MessageModel(message: message, isUser: true, timestamp: timeStamp));
      notifyListeners();

      String response = await generateResponse(message);
      _messages.add(MessageModel(
          message: response,
          isUser: false,
          timestamp: timeStamp.add(Duration(milliseconds: 1))));
      _sortMessages();
      notifyListeners();

      await _storeInFirestore(userId, message, response, timeStamp);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _sortMessages() {
    _messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
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
