import 'package:chat_bot_app/main.dart';
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

  // List<PromptChat> chatHistory = [];
  // PromptChat geminiResponse = PromptChat(sender: MessageSender.gemini, message: '');

  @override
  void initState() {
    super.initState();
    bloc = Provider.of<ChatBloc>(context, listen: false);
    bloc.chatInputSink.add(LoadChatEvent());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
              title: const Text('Texto e imagem',
                  style: TextStyle(color: Colors.blue)),
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
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: bloc.chatOutputStream,
              builder: (context, AsyncSnapshot<ChatState> snapshot) {
                List<PromptChat> chatHistoryFromState = snapshot.data?.chatHistory ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: chatHistoryFromState.length,
                  itemBuilder: (context, index) {
                    return BoxMessage(
                      message: chatHistoryFromState[index].message,
                      sender: chatHistoryFromState[index].sender,
                    );
                  },
                );
              },
            )),
            const SizedBox(height: 20),
            BoxTextField(
              controller: _textEditingController,
              onFieldSubmitted: _handleSubmit,
              labelText: 'Digite aqui sua mensagem',
              suffixIcons: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _handleSubmit,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_textEditingController.text.isEmpty) scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(content: Text('Digite uma mensagem')));
    bloc.chatInputSink.add(SendMessageChatEvent(promptMessage: PromptChat(sender: MessageSender.user, message: _textEditingController.text)));
    _textEditingController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

}
