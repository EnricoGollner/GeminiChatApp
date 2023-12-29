// import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:provider/provider.dart';

// abstract class IChatRepository {
//   Future<void> saveChatHistory(List<PromptChat> chatHistory);
//   Future<List<PromptChat>> getChatHistory();
// }

// class ChatRepository implements IChatRepository {
//   final BuildContext context;
//   const ChatRepository({required this.context});

//   @override
//   Future<List<PromptChat>> getChatHistory() async {
//     final List<Map<String, dynamic>> chatHistoryJson = await Provider.of<Box>(context, listen: false).get('chatHistory', defaultValue: List<Map<String, dynamic>>.empty(growable: true));
//     final List<PromptChat> chatHistory = chatHistoryJson.map((e) => PromptChat.fromJson(e)).toList();

//     return chatHistory;
//   }

//   @override
//   Future<void> saveChatHistory(List<PromptChat> chatHistory) async {
//     final List<Map<String, dynamic>> chatHistoryJson = chatHistory.map((e) => e.toJson()).toList();
//     await Provider.of<Box>(context, listen: false).put('chatHistory', chatHistoryJson);
//   }
// }
