import 'package:chat_poc/chat_feature/data/models/chat_request.dart';
import 'package:dio/dio.dart';

class ChatService {
  final Dio dio;

  ChatService({required this.dio});

  Future<dynamic> sendMessage(ChatRequest request) async {
    final response = await dio.post(
      "http://172.26.103.57:8000/api/v1/chat/",
      data: request.toJson(),
    );
    return response.data;
  }
}
