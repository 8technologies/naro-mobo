import 'package:flutter/material.dart';
import 'package:marcci/models/chat_bot/MessageModel.dart';

class MessageTile extends StatelessWidget {
  final Message message;

  const MessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    final isFarmer = message.sender == 'farmer';
    return Align(
      alignment: isFarmer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isFarmer ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment:
              isFarmer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isFarmer ? Colors.white : Colors.black,
              ),
            ),
            if (message.respondedBy != null && message.respondedBy == 'expert')
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Expert: ${message.expert?.name ?? 'Unknown'}',
                  style: TextStyle(
                    color: isFarmer ? Colors.white70 : Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
