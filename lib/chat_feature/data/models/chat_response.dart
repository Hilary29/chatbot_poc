import 'package:chat_poc/chat_feature/data/models/chat_button.dart';

class ChatResponse {
  final String? recipientId;
  final String? text;
  final List<ChatButton>? buttons;

  const ChatResponse({this.recipientId, this.text, this.buttons});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      recipientId: json['recipient_id'] as String?,
      text: json['text'] as String?,
      buttons: json['buttons'] != null
          ? (json['buttons'] as List)
              .map((b) => ChatButton.fromJson(b))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient_id': recipientId,
      'text': text,
      'buttons': buttons?.map((b) => b.toJson()).toList(),
    };
  }
}
