import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahai/models/message_model.dart';
import 'package:sahai/providers/base_chat_provider.dart';
import 'package:sahai/services/api_service.dart';

class ChatProvider with ChangeNotifier, BaseChatProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _lastMessageTime = DateTime.now();
  final int _pageSize = 30;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isInitialFetch = true; // Track if this is the first fetch

  // Getter for loading state
  bool get isLoading => _isLoading;
  bool get hasMoreMessages => _hasMore;
  bool get isInitialFetch => _isInitialFetch;

  // In ChatProvider class
  Future<void> fetchMessages(String userId, {bool loadMore = false}) async {
    if (!loadMore) {
      messageList.clear();
      _lastDocument = null;
      _hasMore = true;
      _isInitialFetch = true;
    }

    if (!_hasMore || _isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Always fetch in descending order (newest first) for consistency
      Query query = _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .orderBy('deliveryTime', descending: true)
          .limit(_pageSize);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        _hasMore = false;
        _isLoading = false;
        _isInitialFetch = false;
        notifyListeners();
        return;
      }

      _lastDocument = snapshot.docs.last;

      if (snapshot.docs.length < _pageSize) {
        _hasMore = false;
      }

      List<MessageModel> newMessages = [];

      // Process messages in pairs
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final deliveryTime = (data['deliveryTime'] as Timestamp).toDate();

        // Create a pair of messages with user first, then bot
        // Create user message with exact timestamp
        newMessages.add(MessageModel(
          message: data['message'],
          isUser: true,
          timestamp: deliveryTime,
        ));

        // Create response message with slightly later timestamp
        newMessages.add(MessageModel(
          message: data['response'],
          isUser: false,
          timestamp: deliveryTime.add(Duration(milliseconds: 1)),
        ));
      }

      // Since we're fetching newest first, reverse to get oldest first
      newMessages = newMessages.reversed.toList();

      // Check for duplicates
      List<MessageModel> filteredMessages = [];
      for (var msg in newMessages) {
        bool isDuplicate = messageList.any((existingMsg) =>
            existingMsg.message == msg.message &&
            existingMsg.isUser == msg.isUser &&
            existingMsg.timestamp.difference(msg.timestamp).inSeconds.abs() <
                3);

        if (!isDuplicate) {
          filteredMessages.add(msg);
        }
      }

      if (loadMore) {
        // For pagination, add older messages at the beginning
        messageList.insertAll(0, filteredMessages);
      } else {
        // For initial load, simply add messages
        messageList.addAll(filteredMessages);
      }

      // Sort the entire list by timestamp to ensure correct order
      messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      _isLoading = false;
      _isInitialFetch = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isInitialFetch = false;
      setError('Failed to load history: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> loadMoreMessages(String userId) async {
    if (_hasMore && !_isLoading) {
      await fetchMessages(userId, loadMore: true);
    }
  }

  // Split the sendMessage into two functions for separate UI updates
  Future<void> addUserMessage(String userId, String message) async {
    try {
      if (DateTime.now().difference(_lastMessageTime) < Duration(seconds: 1)) {
        return;
      }
      _lastMessageTime = DateTime.now();

      final trimmed = message.trim();
      if (trimmed.isEmpty) return;

      // Add user message to UI with current timestamp
      final messageTimestamp = DateTime.now();
      addMessage(MessageModel(
          message: trimmed, isUser: true, timestamp: messageTimestamp));

      notifyListeners();
    } catch (e) {
      setError('Failed to send message: ${e.toString()}');
      debugPrint('Send message error: $e');
    }
  }

  Future<void> addBotResponse(String userId, String message) async {
    try {
      final trimmed = message.trim();
      if (trimmed.isEmpty) return;

      // Generate bot response
      String response = await generateResponse(trimmed);

      // Use a timestamp slightly later than the user message
      final responseTimestamp = DateTime.now();

      // Add bot response to UI
      addMessage(MessageModel(
          message: response, isUser: false, timestamp: responseTimestamp));

      // Store both message and response in Firestore
      await _storeInFirestore(userId, trimmed, response, responseTimestamp);

      notifyListeners();
    } catch (e) {
      setError('Failed to get response: ${e.toString()}');
      debugPrint('Response error: $e');
    }
  }

  // Keep the original function for compatibility
  Future<void> sendMessage(String userId, String message) async {
    await addUserMessage(userId, message);
    await addBotResponse(userId, message);
  }

  // Future<String> generateResponse(String message) async {
  //   // This is a dummy function. Replace with actual API call later.
  //   await Future.delayed(const Duration(seconds: 1));
  //   return 'Mock response to: $message';
  // }
  Future<String> generateResponse(String message) async {
    try {
      final apiService = ApiService();
      return await apiService.getResponse(message);
      print(message);
    } catch (e) {
      setError('API Error: ${e.toString()}');
      return 'Sorry, I encountered an error. Please try again.';
    }
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
