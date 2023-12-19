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
  Content geminiResponse = Content();

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
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSubmit,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    Content userMessage = Content(
        parts: [Parts(text: _textEditingController.text)], role: 'user');
    setState(() {
      chatHistory.add(userMessage);
      _textEditingController.clear();
    });
    await gemini.chat([userMessage]).then((resposta) => geminiResponse =
        Content(parts: [Parts(text: '${resposta!.output}')], role: 'model'));
    setState(() {
      chatHistory.add(geminiResponse);
    });
  }
}
