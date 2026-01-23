import 'package:chat_poc/chat_feature/data/models/chat_request.dart';
import 'package:chat_poc/chat_feature/data/models/chat_response.dart';
import 'package:chat_poc/chat_feature/data/services/chat_service.dart';

class ChatRepository {
  final ChatService chatService;

  ChatRepository({required this.chatService});

  Future<ChatResponse?> sendMessage(ChatRequest request) async {
    var json = await chatService.sendMessage(request);
    ChatResponse chatResponse = ChatResponse.fromJson(json);
    return chatResponse;
  }
}
