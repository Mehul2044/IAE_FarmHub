import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final apiService = ApiService();
  String responseText = '';
  String nm = FirebaseAuth.instance.currentUser!.displayName!.split(' ')[0];
  ChatUser myself = ChatUser(
      id: '1',
      firstName: FirebaseAuth.instance.currentUser!.displayName!.split(' ')[0]);
  ChatUser bot = ChatUser(id: '2', firstName: 'Kisan Mitra');
  List<ChatMessage> allMessages = [
    ChatMessage(
        user: ChatUser(id: '0', firstName: 'Default'),
        createdAt: DateTime.now(),
        text: "किसान मित्र हिंदी में भी उपलब्ध है !!!"),
    ChatMessage(
        user: ChatUser(id: '0', firstName: 'Default'),
        createdAt: DateTime.now(),
        text: "नमस्ते, किसान! आज मैं आपकी खेती में कैसे सहायता कर सकता हूँ?"),
    ChatMessage(
        user: ChatUser(id: '0', firstName: 'Default'),
        createdAt: DateTime.now(),
        text: 'Namaste, Kisan ! How can I assist you with your farming today?'),
    ChatMessage(
        user: ChatUser(id: '0', firstName: 'Default'),
        createdAt: DateTime.now(),
        text:
            'Please provide information regarding your location and crop type while asking questions.'),
    ChatMessage(
        user: ChatUser(id: '0', firstName: 'Default'),
        createdAt: DateTime.now(),
        text:
            'What do you need assistance with on your farm? Type your question or concern below.'),
    ChatMessage(
        user: ChatUser(id: '0', firstName: 'Default'),
        createdAt: DateTime.now(),
        text:
            'What specific aspect of farming do you need advice on? Feel free to ask about crops, livestock, or agricultural practices.'),
    ChatMessage(
        user: ChatUser(id: '0', firstName: 'Default'),
        createdAt: DateTime.now(),
        text:
            "If you're unsure how to proceed or need assistance, simply type 'Help' and I'll be happy to provide further support."),
  ];
  final impUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$API_GEMINI';
  final header = {'Content-Type': 'application/json'};
  void _showErrorSnackBar(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.toString()),
      backgroundColor: Colors.red,
    ));
  }

  List<ChatUser> typers = [];
  getData(ChatMessage m) async {
    allMessages.insert(0, m);
    setState(() {
      typers.insert(0, bot);
    });
    try {
      GenerateContentResponse temp2 =
          await apiService.sendMessageGemini(text: m.text);
      responseText = temp2.text!;
      ChatMessage m1 = ChatMessage(
        user: bot,
        createdAt: DateTime.now(),
        text: responseText,
      );
      print(m1.text);
      allMessages.insert(0, m1);
      setState(() {
        typers = [];
      });
    } catch (error) {
      _showErrorSnackBar(error);
    } finally {
      setState(() {
        typers = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Row(
        children: [Text('Kisan Mitra'), Icon(Icons.adb_sharp)],
      )),
      body: DashChat(
          typingUsers: typers,
          currentUser: myself,
          onSend: (ChatMessage m) {
            getData(m);
          },
          messages: allMessages),
    );
  }
}
