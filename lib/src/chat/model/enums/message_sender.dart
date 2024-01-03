import 'package:hive/hive.dart';

part 'message_sender.g.dart';

@HiveType(typeId: 3)
enum MessageSender {
  @HiveField(3)
  user,
  @HiveField(4)
  gemini,
}
