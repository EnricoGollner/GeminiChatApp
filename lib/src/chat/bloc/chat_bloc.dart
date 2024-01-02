import 'dart:async';

import 'package:chat_bot_app/src/chat/bloc/chat_event.dart';
import 'package:chat_bot_app/src/chat/bloc/chat_state.dart';
import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatBloc {
  // final ChatRepository _chatRepository;

  final StreamController<ChatEvent> _chatInputController =
      StreamController<ChatEvent>();
  final StreamController<ChatState> _chatOutputController =
      StreamController<ChatState>();

  Sink<ChatEvent> get chatInputSink => _chatInputController.sink;
  Stream<ChatState> get chatOutputStream => _chatOutputController.stream;

  List<Content> chat = [];

  ChatBloc(/*{required ChatRepository chatRepository}*/) {
    _chatInputController.stream.listen(
      (event) async {
        await _mapEventToState(event);
      },
    );
  }

  Future<void> _mapEventToState(ChatEvent event) async {
    // List<PromptChat> chatHistory = await _chatRepository.getChatHistory();
    List<PromptChat> chatHistory = [];

    if (event is LoadChatEvent) {
      _chatOutputController.add(ChatLoadingState(chatHistory: chatHistory));

      await Gemini.instance.text('Olá!').then((response) => chatHistory.add(
          PromptChat(
              sender: MessageSender.gemini, message: response?.output ?? '')));
    } else if (event is SendMessageChatEvent) {
      _chatOutputController
          .add(ChatLoadingState(chatHistory: event.chatHistory));

      chatHistory = event.chatHistory;
      chatHistory.add(event.message);

      chat.add(
        Content(
          parts: [Parts(text: event.message.message)],
          role: 'user',
        ),
      );

      await Gemini.instance.chat(chat).then((response) {
        chatHistory.add(PromptChat(
            sender: MessageSender.gemini, message: response?.output ?? ''));
        chat.add(
          Content(
            parts: [Parts(text: response?.output)],
            role: 'model',
          ),
        );
      });
    }

    _chatOutputController.add(ChatSuccessState(
        userMessage: chatHistory.last, chatHistory: chatHistory));
  }

  void dispose() {
    _chatInputController.close();
    _chatOutputController.close();
  }
}
