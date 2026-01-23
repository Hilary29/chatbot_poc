class ChatResponse {
  final String? answer;
  final String? intent;
  final List<String>? sources;

  const ChatResponse({this.answer, this.intent, this.sources});

    factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      answer: json['answer'] as String?,
      intent: json['intent'] as String?,
      sources: json['sources'] != null
          ? List<String>.from(json['sources'])
          : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'intent': intent,
      'sources': sources,
    };
  }
}

