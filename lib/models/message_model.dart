class MessageModel {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  MessageModel({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}
