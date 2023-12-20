import 'package:chat_bot_app/src/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  Gemini.init(apiKey: 'AIzaSyDxcLVQbF3IuJFd9xvsVXlVQqoFLCiJTgU');

  runApp(const ChatApp());
}
