import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:marcci/models/chat_bot/ConversationModel.dart';
import 'package:marcci/utils/AppConfig.dart';

class ChatService {
  // Base URL of your Laravel API
  // static const String apiUrl = 'http://your-laravel-api.com/api';
  static final String apiUrl = AppConfig.API_BASE_URL;

  // Start a new conversation
  Future<int> startNewConversation(int userId, String message) async {
    final url = Uri.parse('$apiUrl/chat');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'message': message,
      }),
    );

    if (response.statusCode == 202) {
      final data = jsonDecode(response.body);
      return data['conversation_id']; // Return the conversation ID
    } else {
      throw Exception('Failed to start conversation: ${response.body}');
    }
  }

  // Fetch all conversations for a user
  Future<List<Conversation>> fetchConversations(int userId) async {
    final url = Uri.parse('$apiUrl/conversations?user_id=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the response and ensure it is a Map
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the list of conversations from the 'data' key
      List conversations = data['data'] ?? [];

      // Map each conversation to the Conversation model
      return conversations.map((c) => Conversation.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load conversations: ${response.body}');
    }
  }

  // Send a message in an existing conversation
  Future<void> sendMessage(int conversationId, String message) async {
    final url = Uri.parse('$apiUrl/conversations/$conversationId/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  // Poll for conversation response
  Future<Conversation> getChatResponse(int conversationId) async {
    final url = Uri.parse('$apiUrl/conversations/$conversationId/response');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the response and ensure it's a Map
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the conversation data
      final conversationData = data['data'];

      if (conversationData == null ||
          conversationData['status'] == 'processing') {
        throw Exception(
            'Processing'); // Indicate that processing is still ongoing
      } else {
        // Return the conversation object
        return Conversation.fromJson(conversationData);
      }
    } else {
      throw Exception('Error fetching response: ${response.body}');
    }
  }
}
