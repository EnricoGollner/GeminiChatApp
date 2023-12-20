import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';

class PromptChat {
  final MessageSender sender;
  final String message;

  PromptChat({required this.sender, required this.message});
}
