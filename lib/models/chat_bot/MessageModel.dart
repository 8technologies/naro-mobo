class Message {
  final int id;
  final String sender;
  final String message;
  final String messageType;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.message,
    required this.messageType,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      message: json['message'],
      messageType: json['message_type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}