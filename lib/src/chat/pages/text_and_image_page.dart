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
import 'package:lottie/lottie.dart';

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
  PromptChatAndImage geminiResponse =
      PromptChatAndImage(sender: MessageSender.gemini);
  PromptChatAndImage userMessageWithImage =
      PromptChatAndImage(sender: MessageSender.user);

  Uint8List imageBytes = Uint8List.fromList([]);
  List<Uint8List> imageList = [];
  List<int> imageIndexes = [];

  @override
  void initState() {
    super.initState();

    gemini = Gemini.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await gemini.text('Olá').then((resposta) => geminiResponse =
          PromptChatAndImage(
              sender: MessageSender.gemini, message: resposta!.output ?? ''));

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
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Lottie.asset(
                'assets/logo.json',
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              title: const Text(
                'Apenas texto',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: GeminiResponseTypeView(
        builder: (context, child, response, loading) {
          bool carregando() {
            if (loading && response == null) return true;
            return false;
          }

          if (!loading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
              );
            });
          }

          return Padding(
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
                        images: chatHistory[index].images,
                        message: chatHistory[index].message,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                BoxTextField(
                  controller: _textEditingController,
                  onFieldSubmitted: carregando() ? () {} : _handleSubmit,
                  labelText: 'Digite aqui sua mensagem',
                  suffixIcons: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () => carregando()
                            ? null
                            : _pickImage(source: ImageSource.gallery),
                        color: Colors.green,
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera),
                        onPressed: () => carregando()
                            ? null
                            : _takePhoto(source: ImageSource.camera),
                        color: Colors.green,
                      ),
                      carregando()
                          ? Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Lottie.asset(
                                'assets/loading.json',
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _handleSubmit,
                              color: Colors.blue,
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _takePhoto({required ImageSource source}) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      setState(() {
        imageBytes = file.readAsBytesSync();
        userMessageWithImage =
            userMessageWithImage.copyWith(images: [imageBytes]);
      });
    }
  }

  Future<void> _pickImage({required ImageSource source}) async {
    final List<XFile?> pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      List<Uint8List> imagesChosen = [];
      if (imagesChosen.isNotEmpty) imagesChosen.clear();
      for (var f in pickedFiles) {
        var file = File(f!.path);
        imageBytes = file.readAsBytesSync();
        imagesChosen.add(imageBytes);
      }
      userMessageWithImage =
          userMessageWithImage.copyWith(images: imagesChosen);
    }
  }

  Future<void> _handleSubmit() async {
    userMessageWithImage =
        userMessageWithImage.copyWith(message: _textEditingController.text);

    if (userMessageWithImage.images == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Escolha uma imagem'),
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
    } else if (userMessageWithImage.message.isEmpty) {
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
    } else {
      setState(() {
        chatHistory.add(userMessageWithImage);
        _textEditingController.clear();
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 4),
        curve: Curves.easeInOut,
      );

      await gemini
          .textAndImage(
            text: userMessageWithImage.message,
            images: userMessageWithImage.images!,
          )
          .then(
            (response) => geminiResponse = PromptChatAndImage(
                sender: MessageSender.gemini, message: response?.output ?? ''),
          );

      setState(() {
        chatHistory.add(geminiResponse);
      });
    }
  }
}
