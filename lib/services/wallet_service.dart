import 'dart:convert';
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:chat_blockchain_app/services/secure_storage.dart';
import 'package:hex/hex.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletService {
  /// 1. Genera una nueva identidad Web3 desde cero
  Future<String> createNewWallet() async {
    // Generar mnemónico aleatorio (12 palabras)
    String mnemonic = bip39.generateMnemonic();
    
    // Convertir mnemónico a Seed y luego a Llave Privada
    Uint8List seed = bip39.mnemonicToSeed(mnemonic);

    //Derivar la clave maestra
    bip32.BIP32 masterKey = bip32.BIP32.fromSeed(seed);
    bip32.BIP32 ethKey = masterKey.derivePath("m/44'/60'/0'/0/0");
    
    // Obtener la clave privada (32 bytes) y convertir a hex
    Uint8List privateKeyBytes = ethKey.privateKey!;
    String privateKeyHex = HEX.encode(privateKeyBytes);

    // Guardar mnemónico y clave privada
    await SecureStorage.saveMnemonic(mnemonic);
    await SecureStorage.savePrivateKey(privateKeyHex);

    // Obtener la dirección Ethereum
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKeyHex);
    return credentials.address.hex;
  }

  /// 2. Recuperar la llave privada guardada para firmar/descifrar mensajes
  Future<String?> getPrivateKey() async {
    return await SecureStorage.getPrivateKey();
  }

  /// 3. Obtener la Address (Llave Pública) para mostrar en la app o enviar al servidor
  Future<String?> getPublicAddress() async {
    String? privKey = await getPrivateKey();
    if (privKey == null) return null;
    
    final credentials = EthPrivateKey.fromHex(privKey);
    return credentials.address.hex;
  }

  /// 4. Borrar la wallet (Cerrar sesión)
  Future<void> clearWallet() async {
    await SecureStorage.clearAll();
  }

  static Future<String> signMessage(String message) async {
    try {
      String? privKey = await SecureStorage.getPrivateKey();
      if (privKey == null) throw Exception("Private key not found");
      
      // final Uint8List privateKeyBytes = hexToBytes(privKey);
      // final credentials = EthPrivateKey(privateKeyBytes);
      // final messageBytes = utf8.encode(message);
      // // Firmar con el prefijo estándar de Ethereum
      // final signature = await credentials.signPersonalMessageToUint8List(messageBytes);
      // return '0x${HEX.encode(signature)}';
      // Remove any '0x' prefix and convert hex to bytes
      String cleanHex = privKey.replaceFirst('0x', '');
      Uint8List privateKeyBytes = hexToBytes(cleanHex);
      // Validate the key length
      if (privateKeyBytes.length != 32) {
        throw Exception('Invalid private key length: expected 32 bytes, got ${privateKeyBytes.length}');
      }

      final credentials = EthPrivateKey(privateKeyBytes);
      final messageBytes = utf8.encode(message);
      final signature = await credentials.signPersonalMessageToUint8List(messageBytes);
      return '0x${HEX.encode(signature)}';
    } catch (e) {
        print("Error signing message: $e");
      rethrow;
    }
  }
}