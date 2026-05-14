import 'package:chat_blockchain_app/providers/contacts_provider.dart';
import 'package:chat_blockchain_app/providers/reown_provider.dart';
import 'package:chat_blockchain_app/screens/login_screen_wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_blockchain_app/providers/chat_provider.dart';
// import 'package:chat_blockchain_app/screens/login_screen.dart';
import 'package:chat_blockchain_app/screens/contacts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final contactsProvider = ContactsProvider();
  await contactsProvider.loadContacts(); // opcional: cargar antes de usar

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: contactsProvider),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ReownProvider()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Chat Blockchain',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          // '/': (context) => LoginScreen(),
          '/': (context) => LoginScreenWallet(),
          '/contacts': (context) => ContactsScreen(),
        },
      );
  }
}