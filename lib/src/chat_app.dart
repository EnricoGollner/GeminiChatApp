import 'package:chat_bot_app/src/chat/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.blueAccent,
          onPrimary: Colors.red,
          secondary: Colors.black,
          onSecondary: Colors.white70,
          error: Colors.red,
          onError: Colors.white,
          background: Color.fromARGB(255, 232, 232, 232),
          onBackground: Colors.white,
          surface: Colors.blue,
          onSurface: Colors.white,
        ),
      ),
      home: const ChatPage(),
    );
  }
}
