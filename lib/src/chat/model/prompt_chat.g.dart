// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromptChatAdapter extends TypeAdapter<PromptChat> {
  @override
  final int typeId = 0;

  @override
  PromptChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromptChat(
      sender: fields[0] as MessageSender,
      message: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PromptChat obj) {
    writer
      ..writeByte(2)
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
      other is PromptChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
