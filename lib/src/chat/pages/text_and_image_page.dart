import 'dart:io';
import 'dart:typed_data';

import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat_image.dart';
import 'package:chat_bot_app/src/chat/pages/chat_page.dart';
import 'package:chat_bot_app/src/chat/pages/widgets/box_message.dart';
import 'package:chat_bot_app/src/chat/pages/widgets/box_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class TextAndImagePage extends StatefulWidget {
  const TextAndImagePage({super.key});

  @override
  State<TextAndImagePage> createState() => _TextAndImagePageState();
}

class _TextAndImagePageState extends State<TextAndImagePage> {
  late Gemini gemini;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  List<PromptChatAndImage> chatHistory = [];
  PromptChatAndImage geminiResponse = PromptChatAndImage(sender: MessageSender.gemini, message: '');
  PromptChatAndImage userMessage = PromptChatAndImage(sender: MessageSender.user, message: '');

  Uint8List imageBytes = Uint8List.fromList([]);
  List<Uint8List> imageList = [];
  List<int> imageIndexes = [];

  @override
  void initState() {
    super.initState();

    gemini = Gemini.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await gemini.text('Olá').then((resposta) => geminiResponse = PromptChatAndImage(sender: MessageSender.gemini, message: resposta!.output ?? ''));

      setState(() {
        chatHistory.add(geminiResponse);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Image'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
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
              title: const Text('Apenas texto', style: TextStyle(color: Colors.blue),),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage(),
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
                  return BoxMessage(
                    sender: chatHistory[index].sender,
                    image: chatHistory[index].imageBytes,
                    message: chatHistory[index].message,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BoxTextField(
              controller: _textEditingController,
              onFieldSubmitted: _handleSubmit,
              labelText: 'Digite aqui sua mensagem',
              suffixIcons: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () => _pickImage(source: ImageSource.gallery),
                      color: Colors.green,
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera),
                      onPressed: () => _pickImage(source: ImageSource.camera),
                      color: Colors.green,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _handleSubmit,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage({required ImageSource source}) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      setState(() {
        imageBytes = file.readAsBytesSync();
        userMessage = userMessage.copyWith(imageBytes: imageBytes);
      });
    }
  }

  Future<void> _handleSubmit() async {
    userMessage = userMessage.copyWith(message: _textEditingController.text);
    
    if (userMessage.imageBytes != null && userMessage.message.isNotEmpty) {
      setState(() {
        chatHistory.add(userMessage);
        _textEditingController.clear();
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      });

      await gemini.textAndImage(
            text: _textEditingController.text,
            image: imageBytes,
          ).then(
            (response) => geminiResponse = PromptChatAndImage(sender: MessageSender.gemini, message: response?.output ?? ''),
          );

      setState(() {
        chatHistory.add(geminiResponse);
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      });
    }
  }
}
