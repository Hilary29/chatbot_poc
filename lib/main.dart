import 'package:chat_poc/chat_feature/business_logic/chat_bloc.dart';
import 'package:chat_poc/chat_feature/data/repositories/chat_repository.dart';
import 'package:chat_poc/chat_feature/data/services/chat_service.dart';
import 'package:chat_poc/chat_feature/presentation/chat_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialisation des dépendances
    final dio = Dio();
    final chatService = ChatService(dio: dio);
    final chatRepository = ChatRepository(chatService: chatService);

    return MaterialApp(
      title: 'chat POC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => ChatBloc(chatRepository: chatRepository),
        child: const ChatScreen(),
      ),
    );
  }
}
