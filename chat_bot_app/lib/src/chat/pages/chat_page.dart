import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Gemini gemini;

  @override
  void initState() {
    super.initState();

    gemini = Gemini.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      gemini
          .text("Hello, there!!")
          .then((value) => print(value?.output))
          .catchError((e) => print(e));
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
              child: StreamBuilder(stream: gemini., builder: (context, snapshot) { 
                return ListView.builder(itemBuilder: (context, index) { 
                  return ListTile(title: Text(snapshot.data[index].output),); 
                }, itemCount: snapshot.data.length,); 
              }),
            ),
            Container(
              child: TextFormField(),
            )
          ],
        ),
      ),
    );
  }


}
