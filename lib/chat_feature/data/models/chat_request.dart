class ChatRequest {
  final String? sender;
  final String? message;

  const ChatRequest({this.sender, this.message});

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      sender: json['sender'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
    };
  }
}
