import 'package:chat_bot_app/src/chat/bloc/chat_bloc.dart';
import 'package:chat_bot_app/src/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  String apiKey = dotenv.env['API_KEY']!;
  Gemini.init(apiKey: apiKey);

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('ChatPersistence');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      systemNavigationBarColor: Colors.blue,
      systemNavigationBarDividerColor: Colors.blue,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        // Provider<Box>(
        //   create: (_) => Hive.box('ChatPersistence'),
        //   dispose: (_, Box box) => box.close(),
        // ),
        Provider<ChatBloc>(
          create: (BuildContext context) => ChatBloc(/*chatRepository: ChatRepository(context: context)*/),
          dispose: (_, ChatBloc bloc) => bloc.dispose(),
        ),
      ],
      child: const ChatApp(),
    ),
  );
}
