import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_blockchain_app/providers/chat_provider.dart';
import 'package:chat_blockchain_app/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String contactAddress;
  const ChatScreen({required this.contactAddress});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
    final messages = provider.messages.where((m) =>
      m.from == widget.contactAddress || m.to == widget.contactAddress).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.contactAddress)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (_, i) => MessageBubble(
                message: messages[i],
                isMe: messages[i].from == provider.myAddress,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Escribe un mensaje...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      provider.sendMessage(widget.contactAddress, text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}