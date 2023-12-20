import 'package:chat_bot_app/src/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  String apiKey = dotenv.env['API_KEY']!;
  Gemini.init(apiKey: apiKey);
  runApp(const ChatApp());
}
