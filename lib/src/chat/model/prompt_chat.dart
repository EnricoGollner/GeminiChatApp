// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:hive_flutter/adapters.dart';

part 'prompt_chat.g.dart';

@HiveType(typeId: 0)
class PromptChat {
  @HiveField(0)
  final MessageSender sender;
  @HiveField(1)
  final String message;

  PromptChat({required this.sender, required this.message});
}
