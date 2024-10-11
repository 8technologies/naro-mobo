import 'package:marcci/models/chat_bot/MessageModel.dart';

class Conversation {
  final int id;
  final int userId;
  final String status;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.userId,
    required this.status,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var messagesFromJson = json['messages'] as List;
    List<Message> messageList =
        messagesFromJson.map((m) => Message.fromJson(m)).toList();

    return Conversation(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      messages: messageList,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
          DateTime.parse(json['updated_at']), // Ensure updated_at is parsed
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, userId: $userId, status: $status, messages: ${messages.length})';
  }
}
