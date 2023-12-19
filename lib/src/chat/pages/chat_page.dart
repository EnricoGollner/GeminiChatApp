import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Gemini gemini;
  final TextEditingController _textEditingController = TextEditingController();

  List<Content> chatHistory = [];

  Content conteudo = Content();

  @override
  void initState() {
    super.initState();

    gemini = Gemini.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: gemini.chat([
                    _textEditingController.text.isEmpty
                        ? Content(parts: [Parts(text: 'Olá')], role: '')
                        : conteudo,
                  ]),
                  builder: (context, snapshot) {
                    Content geminiResponse = Content(parts: [
                      Parts(
                          text: _textEditingController.text.isEmpty
                              ? ''
                              : snapshot.data?.output)
                    ], role: 'model');
                    chatHistory.add(geminiResponse);
                    return snapshot.connectionState == ConnectionState.done
                        ? ListView.builder(
                            itemCount: chatHistory.length,
                            itemBuilder: (context, index) {
                              Parts messagePart = chatHistory[index].parts![0];
                              String role = chatHistory[index].role!;

                              return ListTile(
                                title: Text(messagePart.text!),
                                subtitle: Text(role),
                              );
                            },
                          )
                        : const Padding(padding: EdgeInsets.all(0));
                  }),
            ),
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Digite algo',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSubmit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    setState(() {
      Content userMessage = Content(
          parts: [Parts(text: _textEditingController.text)], role: 'user');
      chatHistory.add(userMessage);
      _textEditingController.clear();
    });
  }
}
