import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/api/chat_service.dart';
import 'package:marcci/controllers/MainController.dart';
import 'package:marcci/models/LoggedInUserModel.dart';
import 'package:marcci/models/chat_bot/ConversationModel.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:marcci/theme/custom_theme.dart';

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
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    _conversationFuture = _fetchConversation();
  }

  Future<Conversation> _fetchConversation() async {
    try {
      log('Fetching conversation for ID: ${widget.conversationId}');
      final conversation = await _apiService.getChatResponse(
          widget.conversationId, mainController.loggedInUserModel.id);
      setState(() {
        _conversation = conversation;
      });
      log('Fetched conversation: $conversation');
      return conversation;
    } catch (e) {
      log('Error fetching conversation: $e');
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
      await _apiService.sendMessage(widget.conversationId,
          _messageController.text.trim(), mainController.loggedInUserModel.id);
      _messageController.clear();
      _conversationFuture = _fetchConversation(); // Refresh the conversation
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
        final updatedConversation = await _apiService.getChatResponse(
            widget.conversationId, mainController.loggedInUserModel.id);
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
        backgroundColor: CustomTheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleLarge(
              _conversation != null && _conversation!.messages.isNotEmpty
                  ? _conversation!.messages.first.message
                      .split(' ')
                      .take(5)
                      .join(' ')
                  : "Conversation ${widget.conversationId}",
              fontWeight: 800,
              color: Colors.white,
              height: 1.0,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE3E3E3),
                  width: 1.0,
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(42.0, 28.0, 0.0, 28.0),
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF10793D),
                      ),
                    ),
                    child: Icon(
                      Icons.wechat_outlined,
                      color: Color(0xFF10793D),
                      size: 24.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NARO AI Chatbot',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontFamily: 'Inter',
                              color: Color(0xFF454B58),
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                            ),
                      ),
                      Text(
                        'Your groundnut questions answered!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: 'Inter',
                              color: Color(0xFF667085),
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                ),
              ])),
          Expanded(
            child: FutureBuilder<Conversation>(
              future: _conversationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _conversation == null) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  if (snapshot.error.toString().contains("SocketException")) {
                    return Center(
                        child: Text(
                            'Network error. Please check your connection.'));
                  } else {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                } else if (_conversation == null ||
                    _conversation!.messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                } else {
                  final messages = _conversation!.messages;
                  log('Messages: $messages');
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      log('Message at index $index: $message');
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
                            color: isFarmer
                                ? CustomTheme.primary
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: isFarmer
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: isFarmer ? Colors.white : Colors.black,
                                ),
                                maxLines:
                                    null, // Allow text to span multiple lines
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
          const SizedBox(height: 12),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask another question...',
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
                      prefixIcon:
                          Icon(Icons.chat_bubble_outline, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.grey),
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

  Future<int> getLoggedInUserId() async {
    LoggedInUserModel loggedInUser = await LoggedInUserModel.getLoggedInUser();
    return loggedInUser.id;
  }
}
