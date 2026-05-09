import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:web3dart/web3dart.dart';
// import 'package:pointycastle/export.dart';
import 'package:hex/hex.dart';

class CryptoService {
  // Obtener dirección Ethereum desde una clave privada hex
  static String getAddressFromPrivateKey(String privateKeyHex) {
    final privateKey = EthPrivateKey.fromHex(privateKeyHex);
    final publicKeyBytes = privateKey.address.value; // Uint8List (64 bytes)
    return '0x${HEX.encode(publicKeyBytes)}';
  }

  // Firmar un mensaje (útil para el challenge)
  static Future<String> signMessage(String message, String privateKeyHex) async {
    final credentials = EthPrivateKey.fromHex(privateKeyHex);
    final messageBytes = utf8.encode(message);
    // Firmar con el prefijo estándar de Ethereum
    final signature = await credentials.signPersonalMessageToUint8List(messageBytes);
    return '0x${HEX.encode(signature)}';
  }

  // Obtener clave pública (sin comprimir, formato 0x04...)
  static String getPublicKeyFromPrivate(String privateKeyHex) {
    final privateKey = EthPrivateKey.fromHex(privateKeyHex);
    final publicKeyBytes = privateKey.publicKey.getEncoded(false); // Uint8List (64 bytes)
    return HEX.encode(publicKeyBytes);
  }

  // --- Cifrado híbrido ---
  static Uint8List generateSymmetricKey() {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
  }

  // static (Uint8List encryptedKey, Uint8List iv, Uint8List ciphertext, Uint8List authTag) 
  //     encryptMessage(String plainText, String recipientPublicKeyHex) {
  //   // 1. Generar clave simétrica
  //   final symmetricKey = generateSymmetricKey();
    
  //   // 2. Cifrar texto con AES-256-GCM
  //   final iv = Uint8List(12);
  //   final random = Random.secure();
  //   for (int i = 0; i < 12; i++) iv[i] = random.nextInt(256);
    
  //   final plainBytes = utf8.encode(plainText);
  //   final cipher = GCMCipher();
  //   cipher.init(true, AEADParameters(
  //     KeyParameter(symmetricKey),
  //     128,
  //     iv,
  //     Uint8List(0),
  //   ));
  //   final ciphertextWithTag = cipher.process(plainBytes);
  //   final ciphertext = ciphertextWithTag.sublist(0, plainBytes.length);
  //   final authTag = ciphertextWithTag.sublist(plainBytes.length);
    
  //   // 3. Cifrar clave simétrica con ECIES
  //   final publicKeyBytes = HEX.decode(recipientPublicKeyHex.replaceFirst('0x', ''));
  //   final encryptedKey = Ecies.encrypt(publicKeyBytes, symmetricKey);
    
  //   return (encryptedKey, iv, ciphertext, authTag);
  // }

  // static String decryptMessage({
  //   required String encryptedKeyB64,
  //   required String ivB64,
  //   required String ciphertextB64,
  //   required String authTagB64,
  //   required String myPrivateKeyHex,
  // }) {
  //   final encryptedKey = base64Decode(encryptedKeyB64);
  //   final iv = base64Decode(ivB64);
  //   final ciphertext = base64Decode(ciphertextB64);
  //   final authTag = base64Decode(authTagB64);
    
  //   // 1. Descifrar clave simétrica
  //   final privateKeyBytes = HEX.decode(myPrivateKeyHex.replaceFirst('0x', ''));
  //   final symmetricKey = Ecies.decrypt(privateKeyBytes, encryptedKey);
    
  //   // 2. Descifrar AES-GCM
  //   final cipher = GCMCipher();
  //   cipher.init(false, AEADParameters(
  //     KeyParameter(symmetricKey),
  //     128,
  //     iv,
  //     Uint8List(0),
  //   ));
  //   final combined = Uint8List(ciphertext.length + authTag.length);
  //   combined.setAll(0, ciphertext);
  //   combined.setAll(ciphertext.length, authTag);
  //   final plainBytes = cipher.process(combined);
  //   return utf8.decode(plainBytes);
  // }

  // static Future<Map<String, String>> encryptMessageForPublicKey(
  //     String plainText, String recipientPublicKeyHex) async {
  //   // 1. Clave efímera (nuevo par por cada cifrado)
  //   final ephemeralKeyPair = _generateEphemeralKeyPair();
  //   final ephemeralPublicPoint = ephemeralKeyPair.publicKey as ECPoint;
  //   final ephemeralPrivate = ephemeralKeyPair.privateKey as ECPrivateKey;

  //   // 2. Clave pública del destinatario
  //   final recipientPoint = publicKeyHexToPoint(recipientPublicKeyHex);

  //   // 3. Calcular secreto compartido mediante ECDH
  //   final sharedSecret = _ecdhSharedSecret(ephemeralPrivate, recipientPoint);

  //   // 4. Derivar clave simétrica (SHA-256 del secreto)
  //   final symmetricKey = _deriveSymmetricKey(sharedSecret);

  //   // 5. Cifrar el mensaje con AES-256-GCM
  //   final iv = _generateRandomBytes(12);
  //   final plainBytes = utf8.encode(plainText);
  //   final (ciphertext, authTag) = _aesGcmEncrypt(plainBytes, symmetricKey, iv);

  //   // 6. Empaquetar (la clave pública efímera se envía en formato hex sin comprimir)
  //   return {
  //     'ephemeralPublicKey': pointToPublicKeyHex(ephemeralPublicPoint),
  //     'iv': base64Encode(iv),
  //     'ciphertext': base64Encode(ciphertext),
  //     'authTag': base64Encode(authTag),
  //   };
  // }
}