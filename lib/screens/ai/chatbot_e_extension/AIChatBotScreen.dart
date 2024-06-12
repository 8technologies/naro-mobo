import 'package:flutter/material.dart';
import 'package:marcci/models/Message.dart';
import 'package:marcci/screens/ai/chatbot_e_extension/widgets/GlowingSendButtonWidget.dart';
import 'package:marcci/screens/ai/chatbot_e_extension/widgets/SubtleTextField.dart';
import 'package:marcci/theme/app_theme.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:marcci/utils/AppConfig.dart';
import 'package:marcci/utils/Utils.dart';

class AIChatbotScreen extends StatefulWidget {
  @override
  _AIChatbotScreenState createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleLarge(
          'AI Chatbot',
          color: Colors.white,
          fontWeight: 900,
        ),
        backgroundColor: CustomTheme.primary,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(_messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blue : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(10.0),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SubtleTextField(
              controller: _controller,
              hintText: 'Ask your question...',
            ),
          ),
          GlowingSendButtonWidget(
            color: CustomTheme.primary,
            icon: Icons.send,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: _controller.text, isUser: true));
    });

    final response = await _dio.post(AppConfig.API_BASE_URL + "/chat", data: {
      'message': _controller.text,
    });

    _controller.clear();

    if (response.statusCode == 200) {
      setState(() {
        _messages.add(Message(text: response.data['response'], isUser: false));
      });
    } else {
      // Handle the error appropriately in your app
      Utils.toast('Failed to get response from the server.');
    }
  }
}
