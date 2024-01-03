// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:hive/hive.dart';

part 'prompt_chat_image.g.dart';

@HiveType(typeId: 1)
class PromptChatAndImage extends PromptChat {
  @HiveField(2)
  final List<Uint8List>? images;

  PromptChatAndImage({
    required super.sender,
    this.images,
    super.message = '',
  });

  PromptChatAndImage copyWith({
    MessageSender? sender,
    List<Uint8List>? images,
    String? message,
  }) {
    return PromptChatAndImage(
      sender: sender ?? this.sender,
      images: images ?? this.images,
      message: message ?? this.message,
    );
  }
}
