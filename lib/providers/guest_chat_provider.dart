import 'package:flutter/material.dart';
import 'package:sahai/models/message_model.dart';
import 'package:sahai/providers/base_chat_provider.dart';

class GuestChatProvider with ChangeNotifier, BaseChatProvider {
  // Split the sendMessage into two functions for separate UI updates
  void addUserMessage(String message) {
    try {
      final trimmed = message.trim();
      if (trimmed.isEmpty) return;

      // Add user message to UI
      addMessage(MessageModel(
          message: trimmed, isUser: true, timestamp: DateTime.now()));

      notifyListeners();
    } catch (e) {
      setError('Failed to add user message: ${e.toString()}');
    }
  }

  //replace with api
  Future<void> addBotResponse(String message) async {
    try {
      final trimmed = message.trim();
      if (trimmed.isEmpty) return;

      // Generate response
      String response = await generateResponse(trimmed);

      // Add bot response to UI
      addMessage(MessageModel(
          message: response, isUser: false, timestamp: DateTime.now()));

      notifyListeners();
    } catch (e) {
      setError('Failed to get response: ${e.toString()}');
    }
  }

  // Keep the original function for compatibility
  Future<void> sendMessage(String message) async {
    addUserMessage(message);
    await addBotResponse(message);
  }

  Future<String> generateResponse(String message) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Mock response to: $message';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
