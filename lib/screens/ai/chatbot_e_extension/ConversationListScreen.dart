import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:marcci/api/chat_service.dart';
import 'package:marcci/models/chat_bot/ConversationModel.dart';
import 'package:marcci/screens/ai/chatbot_e_extension/ConversationDetailScreen.dart';
import 'package:marcci/screens/ai/chatbot_e_extension/NewConversationScreen.dart';
import 'package:marcci/theme/app_theme.dart';
import 'dart:developer';

class ConversationListScreen extends StatefulWidget {
  final int userId;

  const ConversationListScreen({required this.userId});

  @override
  _ConversationListScreenState createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  late Future<List<Conversation>> _conversations;
  final ChatService _apiService = ChatService();

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    setState(() {
      _conversations = _apiService.fetchConversations(widget.userId);
    });
  }

  Future<void> _refreshConversations() async {
    _loadConversations();
  }

  void _navigateToNewConversation() async {
    final conversationId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewConversationScreen(userId: widget.userId),
      ),
    );

    if (conversationId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ConversationDetailScreen(conversationId: conversationId),
        ),
      );
      _refreshConversations();
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
              "Ask NARO AI Chatbot",
              fontWeight: 800,
              color: Colors.white,
              height: 1.0,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: _navigateToNewConversation,
          ),
        ],
      ),
      body: FutureBuilder<List<Conversation>>(
        future: _conversations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No conversations yet'));
          } else {
            final conversations = snapshot.data!;

            // Sort conversations by the updated_at field in descending order (latest first)
            conversations.sort((a, b) {
              return b.updatedAt.compareTo(a.updatedAt);
            });

            return RefreshIndicator(
              onRefresh: _refreshConversations,
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  final lastMessage = conversation.messages.isNotEmpty
                      ? conversation.messages.last.message
                      : 'No messages yet';

                  return ListTile(
                    title: Text('Conversation ${conversation.id}'),
                    subtitle: Text(
                      lastMessage.length > 100
                          ? '${lastMessage.substring(0, 100)} ...'
                          : lastMessage,
                    ),
                    trailing: Text(conversation.status),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationDetailScreen(
                              conversationId: conversation.id),
                        ),
                      ).then((_) => _refreshConversations());
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
