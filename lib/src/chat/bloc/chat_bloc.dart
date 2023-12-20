import 'dart:async';

import 'package:chat_bot_app/src/chat/bloc/chat_event.dart';
import 'package:chat_bot_app/src/chat/bloc/chat_state.dart';
import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatBloc {
  final StreamController<ChatEvent> _chatInputController = StreamController<ChatEvent>();
  final StreamController<ChatState> _chatOutputController = StreamController<ChatState>();

  Sink<ChatEvent> get chatInputSink => _chatInputController.sink;
  Stream<ChatState> get chatOutputStream => _chatOutputController.stream;

  ChatBloc() {
    _chatInputController.stream.listen((event) async {
      await _mapEventToState(event);
    },);
  }


  Future<void> _mapEventToState(ChatEvent event) async {
    List<PromptChat> chatHistory = [];
    _chatOutputController.add(ChatLoadingState());

    if (event is LoadChatEvent) {
      await Gemini.instance.text('Olá, Gemini!').then(
        (response) => chatHistory.add(PromptChat(sender: MessageSender.gemini, message: response?.output ?? ''))
      );
    } else if (event is SendMessageChatEvent) {
      chatHistory.add(event.promptMessage);
      
      await Gemini.instance.text(event.promptMessage.message).then(
        (response) => chatHistory.add(PromptChat(sender: MessageSender.gemini, message: response?.output ?? ''))
      );
    }

    _chatOutputController.add(ChatSuccessState(userMessage: chatHistory.last, chatHistory: chatHistory));
  }

  void dispose() {
    _chatInputController.close();
    _chatOutputController.close();
  }
}
