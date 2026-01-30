import 'package:chat_poc/chat_feature/data/models/chat_request.dart';
import 'package:dio/dio.dart';

class ChatService {
  final Dio dio;

  ChatService({required this.dio});

  Future<dynamic> sendMessage(ChatRequest request) async {
    final response = await dio.post(
      "http://192.168.1.221:5005/webhooks/rest/webhook",
      data: request.toJson(),
    );
    return response.data;
  }
}
