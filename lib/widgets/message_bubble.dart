import 'package:flutter/material.dart';
import 'package:chat_blockchain_app/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  const MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) Text(message.from.substring(0, 6), style: TextStyle(fontSize: 10)),
            Text(message.text),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute}',
              style: TextStyle(fontSize: 10, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}