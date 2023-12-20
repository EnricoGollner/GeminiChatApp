import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:chat_bot_app/src/chat/pages/text_and_image_page.dart';
import 'package:chat_bot_app/src/chat/pages/widgets/box_message.dart';
import 'package:chat_bot_app/src/chat/pages/widgets/box_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Gemini gemini;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  List<PromptChat> chatHistory = [];
  PromptChat geminiResponse = PromptChat(sender: MessageSender.gemini, message: '');

  @override
  void initState() {
    super.initState();

    gemini = Gemini.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await gemini.text('Olá').then((response) => geminiResponse = PromptChat(sender: MessageSender.gemini, message: response?.output ?? ''));
      setState(() {
        chatHistory.add(geminiResponse);
      });
    });
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {

                  return BoxMessage(sender: chatHistory[index].sender, message: chatHistory[index].message);
                },
              ),
            ),
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
    PromptChat userMessage = PromptChat(sender: MessageSender.user, message: _textEditingController.text);

    setState(() {
      chatHistory.add(userMessage);
      _textEditingController.clear();
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });

    await gemini.text(userMessage.message).then((response) => geminiResponse = PromptChat(sender: MessageSender.gemini, message: response?.output ?? ''));

    setState(() {
      chatHistory.add(geminiResponse);
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }
}
