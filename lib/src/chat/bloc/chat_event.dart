import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';

abstract class ChatEvent {}

class LoadChatEvent extends ChatEvent {}

class SendMessageChatEvent extends ChatEvent {
  final PromptChat promptMessage;

  SendMessageChatEvent({required this.promptMessage});
}
