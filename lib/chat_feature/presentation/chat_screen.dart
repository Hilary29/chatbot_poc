import 'package:chat_poc/chat_feature/business_logic/chat_bloc.dart';
import 'package:chat_poc/chat_feature/data/models/chat_button.dart';
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
  static const userId = "user123";
  List<ChatButton> _currentButtons = [];

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"message": message, "isSentByMe": true});
      _currentButtons = [];
    });

    _controller.clear();
    _scrollToBottom();

    context.read<ChatBloc>().add(
          SendMessageEvent(
            request: ChatRequest(sender: userId, message: message),
          ),
        );
  }

  void _sendButtonPayload(ChatButton button) {
    if (button.payload == null) return;

    setState(() {
      _messages.add({"message": button.title ?? button.payload, "isSentByMe": true});
      _currentButtons = [];
    });

    _scrollToBottom();

    context.read<ChatBloc>().add(
          SendMessageEvent(
            request: ChatRequest(sender: userId, message: button.payload),
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
      backgroundColor: const Color.fromARGB(221, 255, 255, 255),
      appBar: AppBar(title: Text("chat"), centerTitle: true,),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatSuccess) {
            setState(() {
              _messages.add({
                "message": state.chatResponse.text ?? "Pas de réponse",
                "isSentByMe": false,
              });
              _currentButtons = state.chatResponse.buttons ?? [];
            });
            _scrollToBottom();
          } else if (state is ChatFailure) {
            setState(() {
              _messages.add({
                "message": "Le service est indisponible pour le moment.\nVeuillez réessayer dans quelques instants, ou contactez directement un agent.",
                "isSentByMe": false,
              });
              _currentButtons = [];
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_currentButtons.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _messages.length) {
                    return ChatBubble(
                      message: _messages[index]["message"],
                      isSentByMe: _messages[index]["isSentByMe"],
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.start,
                      children: _currentButtons.map((button) {
                        return ElevatedButton(
                          onPressed: () => _sendButtonPayload(button),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(96, 0, 0, 0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            button.title ?? '',
                            style: TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                    ),
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF3E1FAD),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "En train de répondre...",
                            style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 70, 70, 70)),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Entrez un message...",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF3E1FAD),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: state is ChatLoading ? null : _sendMessage,
                        ),
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
