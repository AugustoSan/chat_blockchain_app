import 'package:chat_blockchain_app/providers/contacts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_blockchain_app/providers/chat_provider.dart';
import 'package:chat_blockchain_app/screens/chat_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final provider = Provider.of<ContactsProvider>(context, listen: false);
    await provider.loadContactsFromAPI();
    await provider.loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Contactos'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              provider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Cuenta: ${provider.myAddress}'),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Dirección destino (0x...)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final to = _controller.text.trim();
                if (to.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(contactAddress: to)));
                }
              },
              child: Text('Iniciar chat'),
            ),
          ],
        ),
      ),
    );
  }
}