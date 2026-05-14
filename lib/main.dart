import 'package:chat_blockchain_app/providers/contacts_provider.dart';
import 'package:chat_blockchain_app/providers/reown_provider.dart';
import 'package:chat_blockchain_app/screens/login_screen_wallet.dart';
import 'package:chat_blockchain_app/utils/keys.dart';
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

  // Inicializar Reown después de que el primer frame se dibuje
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Provider.of<ReownProvider>(context, listen: false).initAppKitModal();
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
        title: 'Chat Blockchain',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreenWallet(),
          '/contacts': (context) => ContactsScreen(),
        },
      );
  }
}