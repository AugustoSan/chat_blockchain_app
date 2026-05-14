import 'package:chat_blockchain_app/models/contacts.dart';
import 'package:flutter/material.dart';

class ItemListContact extends StatelessWidget {
  final Contact contact;
  final bool isMe;
  const ItemListContact({required this.contact, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(contact.username[0]),
      ),
      title: Text(contact.username == "" ? contact.address : contact.username),
      subtitle: Text(contact.address),
    );
  }
}