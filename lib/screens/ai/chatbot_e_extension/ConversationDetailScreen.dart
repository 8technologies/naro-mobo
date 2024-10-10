import 'package:flutter/material.dart';
import 'package:marcci/api/chat_service.dart';
import 'package:marcci/models/chat_bot/ConversationModel.dart';

class ConversationDetailScreen extends StatefulWidget {
  final int conversationId;

  const ConversationDetailScreen({required this.conversationId});

  @override
  _ConversationDetailScreenState createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  late Future<Conversation> _conversationFuture;
  final ChatService _apiService = ChatService();
  Conversation? _conversation;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  void _loadConversation() {
    setState(() {
      _conversationFuture = _fetchConversation();
    });
  }

  Future<Conversation> _fetchConversation() async {
    try {
      final conversation =
          await _apiService.getChatResponse(widget.conversationId);
      setState(() {
        _conversation = conversation;
      });
      return conversation;
    } catch (e) {
      if (e.toString().contains('Processing')) {
        // Still processing
        return _conversationFuture;
      } else {
        throw e;
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.sendMessage(
          widget.conversationId, _messageController.text.trim());
      _messageController.clear();
      _loadConversation(); // Refresh the conversation
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

  Future<void> _pollForResponse() async {
    while (_conversation != null && _conversation!.status == 'open') {
      try {
        final updatedConversation =
            await _apiService.getChatResponse(widget.conversationId);
        setState(() {
          _conversation = updatedConversation;
        });
        if (updatedConversation.status == 'closed') break;
      } catch (e) {
        if (!e.toString().contains('Processing')) {
          // Handle other errors
          break;
        }
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation ${widget.conversationId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Conversation>(
              future: _conversationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _conversation == null) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (_conversation == null ||
                    _conversation!.messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                } else {
                  final messages = _conversation!.messages;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      final isFarmer = message.sender == 'farmer';
                      return Align(
                        alignment: isFarmer
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isFarmer ? Colors.blueAccent : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: isFarmer
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message, // Ensure message is a String
                                style: TextStyle(
                                  color: isFarmer ? Colors.white : Colors.black,
                                ),
                              ),
                              if (message.respondedBy != null &&
                                  message.respondedBy == 'expert')
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Expert: ${message.expert?.name ?? 'Unknown'}',
                                    style: TextStyle(
                                      color: isFarmer
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Ask another question...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          _pollForResponse();
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
