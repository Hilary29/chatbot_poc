class ChatButton {
  final String? title;
  final String? payload;

  const ChatButton({this.title, this.payload});

  factory ChatButton.fromJson(Map<String, dynamic> json) {
    return ChatButton(
      title: json['title'] as String?,
      payload: json['payload'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'payload': payload,
    };
  }
}
