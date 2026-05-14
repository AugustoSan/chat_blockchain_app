import 'dart:convert';

// import 'package:chat_blockchain_app/services/wallet_connect_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:web3dart/web3dart.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyPrivate = 'private_key';
  static const _keyAddress = 'address';
  static const _keyPublicKey = 'public_key';
  static const _keyJwt = 'jwt';
  static const _keyContacts = 'contacts';
  static const _wcSession = 'session';

  static Future<void> savePrivateKey(String privateKeyHex) async =>
      await _storage.write(key: _keyPrivate, value: privateKeyHex);
    
  static Future<void> saveSession(Object session) async =>
      await _storage.write(key: _wcSession, value: jsonEncode(session));
    
  static Future<String?> getSession() async {
    return await _storage.read(key: _wcSession);
  }

  static Future<String?> getPrivateKey() async =>
      await _storage.read(key: _keyPrivate);
  
  static Future<void> saveAddress(String address) async =>
      await _storage.write(key: _keyAddress, value: address);
  static Future<String?> getAddress() async =>
      await _storage.read(key: _keyAddress);

  static Future<void> savePublicKey(String publicKeyHex) async =>
      await _storage.write(key: _keyPublicKey, value: publicKeyHex);
  static Future<String?> getPublicKey() async =>
      await _storage.read(key: _keyPublicKey);

  static Future<void> saveJwt(String jwt) async =>
      await _storage.write(key: _keyJwt, value: jwt);
  static Future<String?> getJwt() async =>
      await _storage.read(key: _keyJwt);

  static Future<void> clearAll() async =>
      await _storage.deleteAll();

  // Contacts (stored as a JSON array string)
  static Future<void> saveContacts(String contactsJson) async =>
      await _storage.write(key: _keyContacts, value: contactsJson);
  static Future<String?> getContacts() async =>
      await _storage.read(key: _keyContacts);
  static Future<void> deleteContacts() async =>
      await _storage.delete(key: _keyContacts);
}