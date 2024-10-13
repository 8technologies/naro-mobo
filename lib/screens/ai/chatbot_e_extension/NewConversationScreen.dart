import 'package:flutter/material.dart';
import 'package:marcci/api/chat_service.dart';
import 'package:marcci/theme/custom_theme.dart';

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
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Conversation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              textAlign: TextAlign.center, // Center the hint text
              decoration: InputDecoration(
                hintText: 'Ask your question...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontFamily: 'Inter',
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: CustomTheme.primary
                    .withOpacity(0.1), // Subtle greenish color
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomTheme.primary, // Set button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set radius
                      ),
                    ),
                    onPressed: _startConversation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      child: Text(
                        'Start Conversation',
                        style: TextStyle(
                          fontSize: 16, // Set text size
                          color: Colors.white, // Set text color
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
