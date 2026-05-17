import 'package:chat_blockchain_app/providers/reown_provider.dart';
import 'package:chat_blockchain_app/services/api_service.dart';
import 'package:chat_blockchain_app/services/secure_storage.dart';
import 'package:chat_blockchain_app/services/wallet_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  String? _jwtToken;
  String? _userAddress;
  bool _isLoggedIn = false;

  String? get jwtToken => _jwtToken;
  String? get userAddress => _userAddress;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _loadSession();
  }

  // Cargar session guardada (JWT + address)
  Future<void> _loadSession() async {
    _jwtToken = await SecureStorage.getJwt();
    _userAddress = await SecureStorage.getAddress();
    _isLoggedIn = _jwtToken != null && _userAddress != null;
    notifyListeners();
  }

  // Guardar sesión después de login exitoso
  Future<void> saveSession(String jwt, String address) async {
    await SecureStorage.saveAddress(address);
    await SecureStorage.saveJwt(jwt);
    _jwtToken = jwt;
    _userAddress = address;
    _isLoggedIn = true;
    notifyListeners();
  }

  // Cerrar sesión (borrar JWT)
  Future<void> removeSession() async {
    await SecureStorage.clearAll();
    _jwtToken = null;
    _userAddress = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Este método ahora verifica PRIMERO si ya hay sesión de usuario
  Future<bool> isUserLoggedIn() async {
    await _loadSession();
    if (jwtToken != null && userAddress != null) {
      // Verificar si el JWT sigue siendo válido (opcional)
      // Podrías llamar a un endpoint /verify
      return true;
    }
    return false;
  }

  Future<String> requestChallenge() async {
    if (_userAddress == null) {
      throw Exception("User not logged in");
    }
    return await _api.getChallenge(_userAddress!);
  }

  // Future<void> login(BuildContext context, ReownProvider reownProvider) async {
  //   // 1. Verificar que la wallet ESTÁ conectada (WalletConnect)
  //   if (!reownProvider.isConnected) {
  //     throw Exception("Primero debes conectar tu wallet");
  //   }

  //   final address = reownProvider.getAddress();

  //   if (address == null) {
  //     print("Error: No se pudo obtener la dirección del proveedor Reown.");
  //     return;
  //   }
    
  //   final challenge = await _api.getChallenge(address);
  //   final signatureFuture = await reownProvider.signMessage(challenge);

  //   if(signatureFuture == null) {
  //     print("Error: No se pudo obtener la firma del mensaje.");
  //     return;
  //   }

  //   final loginData  = await _api.login(address, signatureFuture, challenge);
  //   final jwt = loginData['token']!;
  //   await saveSession(jwt, address);
  //   notifyListeners();
  // }

  Future<void> loginWithWalletService(String address) async {
    try {
      final challenge = await _api.getChallenge(address);
      final signature = await WalletService.signMessage(challenge);
      final loginData  = await _api.login(address, signature, challenge);
      final jwt = loginData['token']!;
      await saveSession(jwt, address);
      notifyListeners(); 
    } catch (e) {
      print("Error logging in with wallet service: $e");
    }
  }

  Future<void> logout() async {
    await removeSession();
    notifyListeners();
  }

}