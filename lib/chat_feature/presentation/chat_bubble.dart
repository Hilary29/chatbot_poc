import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const ChatBubble({super.key, required this.message, required this.isSentByMe});
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isSentByMe ? Color(0xFF3E1FAD) : Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isSentByMe ? Radius.circular(15) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(115, 143, 135, 135),
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
          softWrap: true,  // Ensures line breaks are handled properly
        ),
      ),
    );
  }
}