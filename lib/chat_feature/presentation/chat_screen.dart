import 'package:chat_poc/chat_feature/business_logic/chat_bloc.dart';
import 'package:chat_poc/chat_feature/data/models/chat_request.dart';
import 'package:chat_poc/chat_feature/presentation/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"message": message, "isSentByMe": true});
    });

    _controller.clear();
    _scrollToBottom();

    // Envoyer le message via le BLoC
    context.read<ChatBloc>().add(
      SendMessageEvent(
        request: ChatRequest(question: message, includeSources: true),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat App")),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatSuccess) {
            setState(() {
              _messages.add({
                "message": state.chatResponse.answer ?? "Pas de réponse",
                "isSentByMe": false,
              });
            });
            _scrollToBottom();
          } else if (state is ChatFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Erreur: ${state.errorMessage}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: _messages[index]["message"],
                    isSentByMe: _messages[index]["isSentByMe"],
                  );
                },
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "En train de répondre...",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Entrez un message...",
                        border: OutlineInputBorder(),
                      ),
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: Icon(Icons.send),
                        onPressed: state is ChatLoading ? null : _sendMessage,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
