import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../controllers/MainController.dart';
import '../../../models/RespondModel.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/Utils.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class QuestionModel {
  String question;
  String answer;
  final bool isFromUser;

  QuestionModel(this.question, this.answer, {this.isFromUser = false});
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final MainController mainController = Get.find<MainController>();
  final ScrollController _scrollController = ScrollController();

  // State Management
  List<QuestionModel> _questions = [];
  bool _isAiTyping = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    // A small delay ensures the list has been updated before we scroll.
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _submitQuestion() async {
    // 1. Validate the form
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }
    // Unfocus the text field to hide the keyboard
    FocusScope.of(context).unfocus();

    String question = _formKey.currentState!.fields['question']!.value;

    // 2. Add user's question to the UI immediately
    setState(() {
      _questions.add(QuestionModel(question, "", isFromUser: true));
      _isAiTyping = true; // Show typing indicator
    });
    _scrollToBottom();
    _formKey.currentState!.reset();

    try {
      // 3. Call the API
      question +=
          ". Don't mention M-Omulimisa, but mention NARO AI as the source of the information where applicable.";
      Map<String, dynamic> params = {
        "question": question,
        'phone': '+256783204665'
      };
      RespondModel resp = RespondModel(await Utils.http_post(
          'https://unified.m-omulimisa.com/api/v1/manya-ai-question', params));

      String answer = "Sorry, I encountered an error. Please try again.";
      if (resp.code == 1 && resp.data['message'] != null) {
        answer = resp.data['message'];
      } else if (resp.message.isNotEmpty) {
        answer = resp.message;
      }

      // 4. Add AI's response to the UI
      setState(() {
        _questions.add(QuestionModel(question, answer, isFromUser: false));
      });
    } catch (e) {
      // Handle potential exceptions
      setState(() {
        _questions.add(QuestionModel(question,
            "I'm having trouble connecting. Please check your internet and try again.",
            isFromUser: false));
      });
      Utils.toast("An error occurred: ${e.toString()}", color: Colors.red);
    } finally {
      // 5. Hide typing indicator regardless of success or failure
      setState(() {
        _isAiTyping = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f6fa),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(FeatherIcons.chevronLeft, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleMedium("AI Farming Assistant",
                fontWeight: 700, color: Colors.black),
            FxText.bodySmall("Powered by NARO AI", color: Colors.grey.shade600),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _questions.isEmpty ? _buildEmptyState() : _buildChatList(),
          ),
          _buildTextInputBar(),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: _questions.length + (_isAiTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _questions.length) {
          return _buildTypingIndicator();
        }
        final message = _questions[index];
        return _buildChatMessage(message);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FeatherIcons.cpu, size: 60, color: Colors.grey.shade300),
          SizedBox(height: 24),
          FxText.titleLarge("Hello!",
              fontWeight: 700, color: Colors.grey.shade800),
          FxText.bodyLarge("How can I help you with your farm today?",
              color: Colors.grey.shade600, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildChatMessage(QuestionModel message) {
    bool isFromUser = message.isFromUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isFromUser)
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/ai.png"),
              backgroundColor: Colors.grey.shade200,
              radius: 18,
            ),
          if (!isFromUser) SizedBox(width: 12),
          Flexible(
            child: FxContainer(
              color: isFromUser ? CustomTheme.primary : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft:
                    isFromUser ? Radius.circular(20) : Radius.circular(4),
                bottomRight:
                    isFromUser ? Radius.circular(4) : Radius.circular(20),
              ),
              child: FxText.bodyLarge(
                isFromUser ? message.question : message.answer,
                color: isFromUser ? Colors.white : Colors.black87,
              ),
            ),
          ),
          if (isFromUser) SizedBox(width: 12),
          if (isFromUser)
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/user.png"),
              backgroundColor: Colors.grey.shade200,
              radius: 18,
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/ai.png"),
            backgroundColor: Colors.grey.shade200,
            radius: 18,
          ),
          SizedBox(width: 12),
          FxContainer(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            borderRadiusAll: 20,
            child: FxText(
              "AI is typing...",
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputBar() {
    return FxContainer(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      bordered: true,
      border: Border(top: BorderSide(color: Colors.grey.shade200)),
      child: FormBuilder(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: 'question',
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type your question here...',
                  filled: true,
                  fillColor: Color(0xfff5f6fa),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: "Question cannot be empty."),
                  FormBuilderValidators.minLength(5,
                      errorText: "Question seems too short."),
                ]),
              ),
            ),
            SizedBox(width: 12),
            FloatingActionButton(
              onPressed: _submitQuestion,
              mini: true,
              backgroundColor: CustomTheme.primary,
              child: Icon(FeatherIcons.send, color: Colors.white, size: 20),
              elevation: 2,
            ),
          ],
        ),
      ),
    );
  }
}
