class Message {
  final int id;
  final String sender;
  final String message;
  final String messageType;
  final String? respondedBy;
  final Expert?
      expert; // Nullable expert object if the response was by an expert
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.message,
    required this.messageType,
    this.respondedBy,
    this.expert,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      message: json['message'],
      messageType: json['message_type'],
      respondedBy: json['responded_by'],
      expert: json['expert'] != null
          ? Expert.fromJson(json['expert'])
          : null, // Parsing 'expert' if available
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Expert {
  final int id;
  final String name;

  Expert({
    required this.id,
    required this.name,
  });

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json['id'],
      name: json['name'],
    );
  }
}
