import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

abstract class IChatRepository {
  Future<void> saveChatHistory(List<dynamic> chatHistory);
  Future<List<PromptChat>> getChatHistory();
}

class ChatRepository implements IChatRepository {
  final BuildContext context;
  const ChatRepository({required this.context});

  @override
  Future<List<PromptChat>> getChatHistory() async {
    final List<PromptChat> chatHistory = await Provider.of<Box>(context).get('chatHistory', defaultValue: []);
    return chatHistory;
  }

  @override
  Future<void> saveChatHistory(List chatHistory) async {
    return await Provider.of(context).put('chatHistory', chatHistory);
  }
}
