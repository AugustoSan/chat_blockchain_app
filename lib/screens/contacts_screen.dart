import 'package:chat_blockchain_app/providers/auth_provider.dart';
import 'package:chat_blockchain_app/providers/contacts_provider.dart';
import 'package:chat_blockchain_app/providers/reown_provider.dart';
import 'package:flutter/services.dart';
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // await provider.loadContactsFromAPI();
    await provider.loadContacts();
    authProvider.isUserLoggedIn();
  }

  void _copyAddressToClipboard(String address) {
    // Copia la dirección al portapapeles del sistema
    Clipboard.setData(ClipboardData(text: address));

    // Muestra un mensaje emergente (SnackBar) para confirmar la acción
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dirección copiada al portapapeles'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
    // final reownProvider = Provider.of<ReownProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final myAddress = authProvider.userAddress ?? "No conectado";
    return Scaffold(
      appBar: AppBar(
        title: Text('Contactos'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              provider.disconnect();
              await authProvider.logout();
              // await reownProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _copyAddressToClipboard(myAddress),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.copy, size: 16.0),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        'Dirección: $myAddress',
                        overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es muy largo
                      ),
                    ),
                  ],
                ),
              ),
            ),
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