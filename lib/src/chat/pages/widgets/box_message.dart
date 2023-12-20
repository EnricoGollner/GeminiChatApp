import 'dart:typed_data';

import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:flutter/material.dart';

class BoxMessage extends StatelessWidget {
  final MessageSender sender;
  final Uint8List? image;
  final String message;

  const BoxMessage({super.key, required this.sender, this.image, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: sender == MessageSender.gemini ? Colors.purple : Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: sender == MessageSender.gemini
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: image != null,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.memory(image ?? Uint8List.fromList([]))),
            ),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: sender == MessageSender.gemini ? null : FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          sender == MessageSender.user ? 'Você' : 'Gemini',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
