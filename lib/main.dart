import 'package:chat_bot_app/src/chat/model/enums/message_sender.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat.dart';
import 'package:chat_bot_app/src/chat/model/prompt_chat_image.dart';
import 'package:chat_bot_app/src/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  String apiKey = dotenv.env['API_KEY']!;

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PromptChatAdapter());
  Hive.registerAdapter(PromptChatAndImageAdapter());
  Hive.registerAdapter(MessageSenderAdapter());
  await Hive.openBox('ChatPersistence');

  Gemini.init(apiKey: apiKey);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      systemNavigationBarColor: Colors.blue,
      systemNavigationBarDividerColor: Colors.blue,
    ),
  );

  runApp(
    const ChatApp(),
  );
}
