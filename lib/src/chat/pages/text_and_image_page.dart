import 'dart:io';
import 'dart:typed_data';

import 'package:chat_bot_app/src/chat/pages/chat_page.dart';
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
  final TextEditingController _textEditingController = TextEditingController();

  List<Content> chatHistory = [];
  Content geminiResponse = Content();

  Uint8List imageBytes = Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();

    gemini = Gemini.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await gemini.text('Olá').then((resposta) => geminiResponse =
          Content(parts: [Parts(text: '${resposta!.output}')], role: 'model'));
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
              title: const Text('Apenas texto'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  Parts messagePart = chatHistory[index].parts![0];
                  String role = chatHistory[index].role!;
                  return ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: role == 'user' ? Colors.blue : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        messagePart.text!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        role == 'user' ? 'Você' : 'Gemini',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Digite algo',
                filled: true,
                fillColor: Colors.green[50],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: _pickImage,
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        imageBytes = file.readAsBytesSync();
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (imageBytes.isNotEmpty) {
      Content userMessage = Content(
          parts: [Parts(text: _textEditingController.text)], role: 'user');
      setState(() {
        chatHistory.add(userMessage);
      });

      await gemini
          .textAndImage(
            text: _textEditingController.text,
            image: imageBytes,
          )
          .then(
            (resposta) => geminiResponse = Content(
                parts: [Parts(text: '${resposta!.output}')], role: 'model'),
          );

      setState(() {
        chatHistory.add(geminiResponse);
      });
    }
  }
}
