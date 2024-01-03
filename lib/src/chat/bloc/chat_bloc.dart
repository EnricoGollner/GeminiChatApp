import 'dart:async';

import 'package:chat_bot_app/src/chat/bloc/chat_event.dart';
import 'package:chat_bot_app/src/chat/bloc/chat_state.dart';
import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';

class ChatBloc {
  final StreamController<ChatEvent> _chatInputController =
      StreamController<ChatEvent>();
  final StreamController<ChatState> _chatOutputController =
      StreamController<ChatState>();

  Sink<ChatEvent> get chatInputSink => _chatInputController.sink;
  Stream<ChatState> get chatOutputStream => _chatOutputController.stream;

  List<Content> chat = [];

  var boxChat = Hive.box('ChatPersistence');

  ChatBloc() {
    _chatInputController.stream.listen(
      (event) async {
        await _mapEventToState(event);
      },
    );
  }

  Future<void> _mapEventToState(ChatEvent event) async {
    List<PromptChat> chatHistory = [];

    if (event is LoadChatEvent) {
      var historico = await boxChat.get('chatHistory', defaultValue: []);

      if (historico.isEmpty) {
        _chatOutputController.add(ChatLoadingState(chatHistory: chatHistory));

        await Gemini.instance.text('Olá!').then((response) => chatHistory.add(
            PromptChat(
                sender: MessageSender.gemini,
                message: response?.output ?? '')));
      } else {
        chatHistory = historico.cast<PromptChat>();
      }
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

      await Gemini.instance.chat(chat).then((response) async {
        chatHistory.add(PromptChat(
            sender: MessageSender.gemini, message: response?.output ?? ''));
        chat.add(
          Content(
            parts: [Parts(text: response?.output)],
            role: 'model',
          ),
        );

        await boxChat.put('chatHistory', chatHistory);
      });
    }

    _chatOutputController.add(ChatSuccessState(
        userMessage: chatHistory.last, chatHistory: chatHistory));
  }

  void deleteHistory() async {
    await boxChat.delete('chatHistory');
  }

  void dispose() {
    _chatInputController.close();
    _chatOutputController.close();
  }
}
