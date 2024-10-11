import 'package:flutter/material.dart';
import 'package:marcci/api/chat_service.dart';
import 'package:marcci/models/chat_bot/ConversationModel.dart';

class ConversationProvider with ChangeNotifier {
  final ChatService _apiService = ChatService();
  List<Conversation> _conversations = [];

  List<Conversation> get conversations => _conversations;

  Future<void> loadConversations(int userId) async {
    _conversations = await _apiService.fetchConversations(userId);
    notifyListeners();
  }

  Future<void> addConversation(int userId, String message) async {
    final conversationId =
        await _apiService.startNewConversation(userId, message);
    // Optionally fetch the new conversation
    // _conversations.add(newConversation);
    notifyListeners();
  }

  Future<void> sendMessage(int conversationId, String message) async {
    // await _apiService.sendMessage(conversationId, message);
    // Optionally fetch the updated conversation
    notifyListeners();
  }
}
