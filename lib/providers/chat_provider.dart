import 'package:flutter/foundation.dart';
import 'package:chat_blockchain_app/models/message.dart';
import 'package:chat_blockchain_app/services/api_service.dart';
import 'package:chat_blockchain_app/services/websocket_service.dart';
import 'package:chat_blockchain_app/services/crypto_service.dart';
import 'package:chat_blockchain_app/services/secure_storage.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  WebSocketService? _webSocket;
  List<Message> _messages = [];
  bool _isConnected = false;
  String? _myAddress;
  Map<String, String> _publicKeysCache = {};

  List<Message> get messages => _messages.reversed.toList();
  bool get isConnected => _isConnected;
  String? get myAddress => _myAddress;

  Future<void> authenticate(String privateKeyHex) async {
    final address = CryptoService.getAddressFromPrivateKey(privateKeyHex);
    final challenge = await _api.getChallenge(address);
    final signature = await CryptoService.signMessage(challenge, privateKeyHex);
    final loginData = await _api.login(address, signature, challenge);
    final jwt = loginData['token']!;
    
    // Guardar datos
    await SecureStorage.savePrivateKey(privateKeyHex);
    await SecureStorage.saveAddress(address);
    await SecureStorage.saveJwt(jwt);
    final publicKey = CryptoService.getPublicKeyFromPrivate(privateKeyHex);
    await SecureStorage.savePublicKey(publicKey);
    await _api.registerPublicKey(jwt, publicKey);
    
    _myAddress = address;
    // Conectar WebSocket
    _webSocket = WebSocketService();
    _webSocket!.onMessage = (msg) {
      _messages.add(msg);
      notifyListeners();
    };
    await _webSocket!.connect(jwt, address);
    _isConnected = true;
    notifyListeners();
  }

  Future<void> sendMessage(String toAddress, String text) async {
    final jwt = await SecureStorage.getJwt();
    if (jwt == null) return;
    String recipientPublicKey = _publicKeysCache[toAddress] ?? 
        await _api.getPublicKey(jwt, toAddress);
    _publicKeysCache[toAddress] = recipientPublicKey;
    
    // Crear mensaje local para mostrar inmediatamente
    final localMessage = Message.withRequired(
      from: _myAddress!,
      to: toAddress,
      timestamp: DateTime.now(),
      text: text,
    );
    _messages.add(localMessage);
    notifyListeners();

    _webSocket?.sendEncryptedMessage(toAddress, text, recipientPublicKey);
  }

  void logout() async {
    _webSocket?.disconnect();
    await SecureStorage.clearAll();
    _messages.clear();
    _isConnected = false;
    notifyListeners();
  }
}