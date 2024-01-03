// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_sender.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageSenderAdapter extends TypeAdapter<MessageSender> {
  @override
  final int typeId = 3;

  @override
  MessageSender read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 3:
        return MessageSender.user;
      case 4:
        return MessageSender.gemini;
      default:
        return MessageSender.user;
    }
  }

  @override
  void write(BinaryWriter writer, MessageSender obj) {
    switch (obj) {
      case MessageSender.user:
        writer.writeByte(3);
        break;
      case MessageSender.gemini:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSenderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
