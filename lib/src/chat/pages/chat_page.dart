import 'package:chat_bot_app/src/chat/bloc/chat_bloc.dart';
import 'package:chat_bot_app/src/chat/bloc/chat_event.dart';
import 'package:chat_bot_app/src/chat/bloc/chat_state.dart';
import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:chat_bot_app/src/chat/pages/text_and_image_page.dart';
import 'package:chat_bot_app/src/chat/pages/widgets/box_message.dart';
import 'package:chat_bot_app/src/chat/pages/widgets/box_text_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatBloc bloc = ChatBloc();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  List<PromptChat> chatHistory = [];
  ChatState chatState = ChatInitialState();

  @override
  void initState() {
    super.initState();
    bloc.chatInputSink.add(LoadChatEvent());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatState>(
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
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Chat'),
              actions: [
                IconButton(
                  onPressed: chatState is! ChatSuccessState
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TextAndImagePage(),
                            ),
                          );
                        },
                  icon: const Icon(Icons.image),
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Lottie.asset(
                      'assets/logo.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Colors.grey[200],
                      ),
                      title: const Text(
                        'Excluir chat',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      tileColor: Colors.purple[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      onTap: chatState is! ChatSuccessState
                          ? null
                          : () async {
                              bloc.deleteHistory();
                              setState(() {
                                chatHistory.clear();
                              });
                            },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.grey[200],
                      ),
                      title: const Text(
                        'Sobre',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      tileColor: Colors.purple[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Lottie.asset(
                                'assets/logo.json',
                                height: 140,
                              ),
                              content: const Text(
                                'Esse aplicativo foi feito por Enrico e Lucas para aprender algumas tecnologias, desfrute dessa IA.',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                    onFieldSubmitted:
                        chatState is! ChatSuccessState ? () {} : _handleSubmit,
                    labelText: 'Digite aqui sua mensagem',
                    suffixIcons: chatState is ChatSuccessState
                        ? IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: chatState is! ChatSuccessState
                                ? null
                                : _handleSubmit,
                            color: Colors.blue,
                          )
                        : Lottie.asset(
                            'assets/loading.json',
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ),
          );
        });
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
            onPressed: () => ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(reason: SnackBarClosedReason.hide),
          ),
        ),
      );
      return;
    }

    bloc.chatInputSink.add(
      SendMessageChatEvent(
        message: PromptChat(
            sender: MessageSender.user, message: _textEditingController.text),
        chatHistory: chatHistory,
      ),
    );
    _textEditingController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 4), curve: Curves.easeInOut);
  }
}
