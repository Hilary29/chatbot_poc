
part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final ChatRequest request;
  SendMessageEvent({required this.request});
}
