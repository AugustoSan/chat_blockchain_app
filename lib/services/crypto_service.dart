import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';
import 'package:hex/hex.dart';


class CryptoService {
  static final _domainParams = ECDomainParameters('secp256k1');

  // Obtener dirección Ethereum desde una clave privada hex
  static String getAddressFromPrivateKey(String privateKeyHex) {
    final privateKey = EthPrivateKey.fromHex(privateKeyHex);
    final publicKeyBytes = privateKey.address.addressBytes; // Uint8List (64 bytes)
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

  /// Convierte Uint8List a BigInt (interpretando big-endian)
  static BigInt _bytesToBigInt(Uint8List bytes) {
    return BigInt.parse(hex.encode(bytes), radix: 16);
  }

  /// Convierte BigInt a Uint8List de tamaño fijo (32 bytes para secp256k1)
  static Uint8List _bigIntToBytes32(BigInt n) {
    final hexStr = n.toRadixString(16).padLeft(64, '0');
    return Uint8List.fromList(hex.decode(hexStr));
  }

  /// Genera una clave privada aleatoria de 32 bytes
  Uint8List generateRandomPrivateKey() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(KeyParameter(Uint8List.fromList(List.generate(32, (_) => Random.secure().nextInt(256)))));
    return secureRandom.nextBytes(32);
  }

  /// Obtiene la clave pública (no comprimida, 64 bytes) a partir de la privada (Uint8List)
  static Uint8List privateKeyToPublicKey(Uint8List privateKeyBytes) {
    final privBigInt = _bytesToBigInt(privateKeyBytes);
    final ecPrivate = ECPrivateKey(privBigInt, _domainParams);
    final publicPoint = _domainParams.G * ecPrivate.d!;
    // La multiplicación puede retornar null en la API de pointycastle
    if (publicPoint == null) {
      throw Exception('Failed to derive public key from private key');
    }
    final publicBytes = publicPoint.getEncoded(false); // 0x04 + X + Y
    return Uint8List.sublistView(publicBytes, 1); // eliminar prefijo 0x04
  }

  static Uint8List computeECDH(Uint8List privateKeyBytes, Uint8List publicKeyBytes) {
    final privBigInt = _bytesToBigInt(privateKeyBytes);
    final ecPrivate = ECPrivateKey(privBigInt, _domainParams);

    final fullPublic = Uint8List(65);
    fullPublic[0] = 0x04; // Prefijo para clave pública no comprimida
    fullPublic.setRange(1, 65, publicKeyBytes);
    final publicPoint = _domainParams.curve.decodePoint(fullPublic);
    if (publicPoint == null) {
      throw Exception('Failed to decode public key');
    }
    
    final ecPublic = ECPublicKey(publicPoint, _domainParams);

    final sharedSecret = ecPublic.Q! * ecPrivate.d!;

    if (sharedSecret == null) {
      throw Exception('Failed to compute shared secret');
    }

    final xCoord = sharedSecret.x!.toBigInteger();
    if (xCoord == null) {
      throw Exception('Failed to extract x-coordinate from shared secret');
    }
    return _bigIntToBytes32(xCoord);
  }

  // Uint8List encryptWithPublicKey(Uint8List publicKeyBytes, Uint8List data) {
  //   final ephemeralPrivateKey = generateRandomPrivateKey();
  // }
}