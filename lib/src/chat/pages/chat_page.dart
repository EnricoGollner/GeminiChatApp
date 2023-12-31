import 'package:chat_bot_app/src/chat/bloc/chat_bloc.dart';
import 'package:chat_bot_app/src/chat/bloc/chat_event.dart';
import 'package:chat_bot_app/src/chat/bloc/chat_state.dart';
import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:chat_bot_app/src/chat/pages/text_and_image_page.dart';
import 'package:chat_bot_app/src/chat/pages/widgets/box_message.dart';
import 'package:chat_bot_app/src/chat/pages/widgets/box_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatBloc bloc;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  List<PromptChat> chatHistory = [];
  ChatState chatState = ChatInitialState();

  @override
  void initState() {
    bloc = Provider.of<ChatBloc>(context, listen: false);

    bloc.chatInputSink.add(LoadChatEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Gemini Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Texto e imagem', style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TextAndImagePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<ChatState>(
            stream: bloc.chatOutputStream,
            builder: (context, AsyncSnapshot<ChatState> snapshot) {
              chatHistory = snapshot.data?.chatHistory ?? [];
              chatState = snapshot.data ?? ChatInitialState();
              
              if (chatState is ChatSuccessState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(seconds: 4),
                    curve: Curves.easeInOut,
                  );
                });
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: chatHistory.length,
                      itemBuilder: (context, index) {
                        return BoxMessage(
                          message: chatHistory[index].message,
                          sender: chatHistory[index].sender,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  BoxTextField(
                    controller: _textEditingController,
                    onFieldSubmitted: chatState is !ChatSuccessState ? (){} : _handleSubmit,
                    labelText: 'Digite aqui sua mensagem',
                    suffixIcons: IconButton(
                      icon: chatState is ChatSuccessState
                          ? const Icon(Icons.send)
                          : const CircularProgressIndicator(),
                      onPressed: chatState is !ChatSuccessState ? null : _handleSubmit,
                      color: Colors.blue,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
  }

  Future<void> _handleSubmit() async {
    if (_textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Digite uma mensagem'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(50, 0, 50, 70),
          action: SnackBarAction(
            label: "x",
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.hide),
          ),
        ),
      );
      return;
    }

    bloc.chatInputSink.add(
      SendMessageChatEvent(
        message: PromptChat(sender: MessageSender.user, message: _textEditingController.text),
        chatHistory: chatHistory,
      ),
    );
    _textEditingController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(seconds: 4), curve: Curves.easeInOut);
  }
}
