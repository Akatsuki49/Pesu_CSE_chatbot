import 'package:flutter/material.dart';
import 'package:sahai/models/message_model.dart';

class GuestChatProvider with ChangeNotifier {
  final List<MessageModel> _messages = [];

  List<MessageModel> get messages => List.unmodifiable(_messages);

  Future<void> sendMessage(String message) async {
    final timeStamp = DateTime.now();
    _messages.add(
        MessageModel(message: message, isUser: true, timestamp: timeStamp));
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    String response = await generateResponse(message);
    _messages.add(MessageModel(
        message: response,
        isUser: false,
        timestamp: timeStamp.add(Duration(milliseconds: 1))));
    _sortMessages();
    notifyListeners();
  }

  Future<String> generateResponse(String message) async {
    // This is a dummy function. Replace with actual API call later.
    return 'Mock response to: $message';
  }

  void _sortMessages() {
    _messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}
