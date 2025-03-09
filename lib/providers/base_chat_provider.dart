import 'package:flutter/material.dart';
import 'package:sahai/models/message_model.dart';

mixin BaseChatProvider on ChangeNotifier {
  // Private message storage
  List<MessageModel> _messages = [];
  String? _errorMessage;

  // Public interface
  List<MessageModel> get messages => List.unmodifiable(_messages);
  String? get errorMessage => _errorMessage;

  // Protected method for subclass access
  @protected
  List<MessageModel> get messageList => _messages;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Shared logic
  void _sortMessages() {
    _messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void addMessage(MessageModel message) {
    _messages.add(message);
    _sortMessages();
    notifyListeners();
  }

  void deleteOldMessages({int days = 4}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    _messages.removeWhere((msg) => msg.timestamp.isBefore(cutoff));
    notifyListeners();
  }

  @protected
  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
