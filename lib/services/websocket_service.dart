import 'dart:convert';
import 'package:chat_blockchain_app/config/app_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:chat_blockchain_app/models/message.dart';
import 'package:chat_blockchain_app/services/secure_storage.dart';

typedef OnMessageReceived = void Function(Message message);

class WebSocketService {
  WebSocketChannel? _channel;
  OnMessageReceived? onMessage;

  Future<void> connect(String jwt, String myAddress) async {
    final uri = Uri.parse('${AppConfig.wsUrl}?token=$jwt'); // Cambiar puerto/IP
    _channel = WebSocketChannel.connect(uri);
    
    _channel!.stream.listen((data) async {
      final Map<String, dynamic> json = jsonDecode(data);
      print('Mensaje recibido: $json');
      final message = Message.withRequired(
        from: json['from'],
        to: json['to'],
        timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
        text: json['text'],
      );
      onMessage?.call(message);

      // Descifrar mensaje (si es para mí)
      // if (json['to'] == myAddress) {
      //   final myPrivateKey = await SecureStorage.getPrivateKey();
      //   if (myPrivateKey != null) {
      //     final plainText = CryptoService.decryptMessage(
      //       encryptedKeyB64: json['encryptedKey'],
      //       ivB64: json['iv'],
      //       ciphertextB64: json['ciphertext'],
      //       authTagB64: json['authTag'],
      //       myPrivateKeyHex: myPrivateKey,
      //     );
      //     final message = Message(
      //       from: json['from'],
      //       to: json['to'],
      //       text: plainText,
      //       timestamp: DateTime.parse(json['timestamp']),
      //     );
      //     onMessage?.call(message);
      //   }
      // }
    });
  }

  void sendEncryptedMessage(String toAddress, String text, String recipientPublicKeyHex) async {
    // final (encryptedKey, iv, ciphertext, authTag) = CryptoService.encryptMessage(text, recipientPublicKeyHex);
    // final envelope = {
    //   'encryptedKey': base64Encode(encryptedKey),
    //   'iv': base64Encode(iv),
    //   'ciphertext': base64Encode(ciphertext),
    //   'authTag': base64Encode(authTag),
    //   'to': toAddress,
    //   'from': await SecureStorage.getAddress() ?? '',
    //   'timestamp': DateTime.now().toIso8601String(),
    // };
    final envelope = new Message.withRequired(
      from: await SecureStorage.getAddress() ?? '',
      to: toAddress,
      timestamp: DateTime.now(),
      text: text,
    );
    _channel?.sink.add(jsonEncode(envelope.toJson()));
  }

  void disconnect() async {
    await _channel?.sink.close();
  }
}