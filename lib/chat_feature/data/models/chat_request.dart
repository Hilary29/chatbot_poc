class ChatRequest {
  final String? question;
  final bool? includeSources;

  const ChatRequest({this.question, this.includeSources});

    factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      question: json['question'] as String?,
      includeSources: json['includeSources'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'includeSources': includeSources,
    };
  }


}
