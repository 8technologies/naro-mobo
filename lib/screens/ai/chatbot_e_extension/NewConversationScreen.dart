import 'package:flutter/material.dart';
import 'package:marcci/api/chat_service.dart';

class NewConversationScreen extends StatefulWidget {
  final int userId; // Assuming the farmer's user ID is passed

  const NewConversationScreen({required this.userId});

  @override
  _NewConversationScreenState createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  final ChatService _apiService = ChatService();

  Future<void> _startConversation() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final conversationId = await _apiService.startNewConversation(
        widget.userId,
        _messageController.text.trim(),
      );
      Navigator.pop(
          context, conversationId); // Return conversation ID to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Conversation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Ask your question...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _startConversation,
                    child: const Text('Start Conversation'),
                  ),
          ],
        ),
      ),
    );
  }
}
