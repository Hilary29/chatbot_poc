part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  ChatLoading();
}

class ChatSuccess extends ChatState {
  final ChatResponse chatResponse;
  ChatSuccess(this.chatResponse);
}

class ChatFailure extends ChatState {
  final String errorMessage;

  ChatFailure({required this.errorMessage});
}
