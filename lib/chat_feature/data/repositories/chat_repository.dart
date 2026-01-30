import 'package:chat_poc/chat_feature/data/models/chat_button.dart';
import 'package:chat_poc/chat_feature/data/models/chat_request.dart';
import 'package:chat_poc/chat_feature/data/models/chat_response.dart';
import 'package:chat_poc/chat_feature/data/services/chat_service.dart';

class ChatRepository {
  final ChatService chatService;

  ChatRepository({required this.chatService});

  Future<ChatResponse?> sendMessage(ChatRequest request) async {
    var json = await chatService.sendMessage(request);
    if (json is List && json.isNotEmpty) {
      final texts = json
          .map((item) => item['text'] as String?)
          .where((text) => text != null)
          .join('\n\n');

      // Boutons du dernier message uniquement
      final lastItem = json.last;
      List<ChatButton>? buttons;
      if (lastItem['buttons'] != null) {
        buttons = (lastItem['buttons'] as List)
            .map((btn) => ChatButton.fromJson(btn))
            .toList();
      }

      return ChatResponse(
        recipientId: json[0]['recipient_id'] as String?,
        text: texts,
        buttons: buttons,
      );
    }
    return null;
  }
}
