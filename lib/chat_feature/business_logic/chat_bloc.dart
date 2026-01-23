import 'package:bloc/bloc.dart';
import 'package:chat_poc/chat_feature/data/models/chat_request.dart';
import 'package:chat_poc/chat_feature/data/models/chat_response.dart';
import 'package:flutter/material.dart';

import 'package:chat_poc/chat_feature/data/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<SendMessageEvent>(_chat);
  }

  void _chat(SendMessageEvent event, Emitter<ChatState> emitter) async {
    emitter(ChatLoading());
    try {
      ChatResponse? chatResponse =
          await chatRepository.sendMessage(event.request);
      if (chatResponse != null) {
        emitter(ChatSuccess(chatResponse));
      } else {
        emitter(ChatFailure(errorMessage: "Aucune réponse du serveur"));
      }
    } catch (e) {
      emitter(ChatFailure(errorMessage: e.toString()));
    }
  }
}
