import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';

class ChatState {
  final PromptChat userMessage;
  final List<PromptChat> chatHistory;

  ChatState({required this.userMessage, required this.chatHistory});
}

class ChatInitialState extends ChatState {
  ChatInitialState() : super(userMessage: PromptChat(sender: MessageSender.user, message: ''), chatHistory: []);
}

class ChatLoadingState extends ChatState {
  ChatLoadingState() : super(userMessage: PromptChat(sender: MessageSender.user, message: ''), chatHistory: []);
}

class ChatSuccessState extends ChatState {
  ChatSuccessState({required super.userMessage, required super.chatHistory});
}

class ChatFailureState extends ChatState {
  final String errorMessage;

  ChatFailureState({required PromptChat userMessage, required List<PromptChat> chatHistory, required this.errorMessage}) : super(userMessage: userMessage, chatHistory: chatHistory);
}