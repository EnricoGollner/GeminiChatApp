// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_chat_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromptChatAndImageAdapter extends TypeAdapter<PromptChatAndImage> {
  @override
  final int typeId = 1;

  @override
  PromptChatAndImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromptChatAndImage(
      sender: fields[0] as MessageSender,
      images: (fields[2] as List?)?.cast<Uint8List>(),
      message: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PromptChatAndImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.images)
      ..writeByte(0)
      ..write(obj.sender)
      ..writeByte(1)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptChatAndImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
