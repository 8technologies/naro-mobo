import 'package:flutter/material.dart';
import 'package:marcci/models/chat_bot/ConversationModel.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final lastMessage = conversation.messages.isNotEmpty
        ? conversation.messages.last.message
        : 'No messages yet';

    return ListTile(
      title: Text('Conversation ${conversation.id}'),
      subtitle: Text(lastMessage),
      trailing: Text(conversation.status),
      onTap: onTap,
    );
  }
}
