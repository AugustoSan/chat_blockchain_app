import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_blockchain_app/providers/chat_provider.dart';
import 'package:chat_blockchain_app/screens/login_screen.dart';
import 'package:chat_blockchain_app/screens/contacts_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Chat Blockchain',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/contacts': (context) => ContactsScreen(),
        },
      ),
    );
  }
}