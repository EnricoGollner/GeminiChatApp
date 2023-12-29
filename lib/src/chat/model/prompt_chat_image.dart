// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';

class PromptChatAndImage extends PromptChat {
  final Uint8List? imageBytes;

  PromptChatAndImage({
    required super.sender,
    this.imageBytes,
    super.message = '',
  });

  PromptChatAndImage copyWith({
    MessageSender? sender,
    Uint8List? imageBytes,
    String? message,
  }) {
    return PromptChatAndImage(
      sender: sender ?? this.sender,
      imageBytes: imageBytes ?? this.imageBytes,
      message: message ?? this.message,
    );
  }
}
