import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_blockchain_app/providers/chat_provider.dart';
import 'package:chat_blockchain_app/screens/contacts_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final provider = Provider.of<ChatProvider>(context, listen: false);
      await provider.authenticate(_controller.text.trim());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ContactsScreen()));
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login con Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Clave privada (hex)'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _loading ? CircularProgressIndicator() : ElevatedButton(
              onPressed: _login,
              child: Text('Conectar'),
            ),
          ],
        ),
      ),
    );
  }
}