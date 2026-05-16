import 'package:chat_blockchain_app/providers/reown_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_blockchain_app/models/message.dart';
import 'package:chat_blockchain_app/services/api_service.dart';
import 'package:chat_blockchain_app/services/websocket_service.dart';
// import 'package:chat_blockchain_app/services/crypto_service.dart';
import 'package:chat_blockchain_app/services/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  WebSocketService? _webSocket;
  List<Message> _messages = [];
  // bool _isConnected = false;
  // String? _myAddress;
  Map<String, String> _publicKeysCache = {};

  List<Message> get messages => _messages.reversed.toList();
  // bool get isConnected => _isConnected;
  // String? get myAddress => _myAddress;


  Future<void> sendMessage(String toAddress, String text) async {
    final jwt = await SecureStorage.getJwt();
    final myAddress = await SecureStorage.getAddress();
    
    if (jwt == null || myAddress == null) return;
    
    String recipientPublicKey = _publicKeysCache[toAddress] ?? 
        await _api.getPublicKey(jwt, toAddress);
    _publicKeysCache[toAddress] = recipientPublicKey;

    // Crear mensaje local para mostrar inmediatamente
    final localMessage = Message.withRequired(
      from: myAddress,
      to: toAddress,
      timestamp: DateTime.now(),
      text: text,
    );
    _messages.add(localMessage);
    notifyListeners();

    _webSocket?.sendEncryptedMessage(toAddress, text, recipientPublicKey);
  }

  void disconnect() async {
    _webSocket?.disconnect();
    notifyListeners();
  }
}