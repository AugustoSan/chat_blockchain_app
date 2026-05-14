import 'package:chat_blockchain_app/utils/keys.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reown_appkit/reown_appkit.dart';

class ReownProvider extends ChangeNotifier {
  ReownAppKit? _appKit;
  ReownAppKitModal? _appKitModal;

  ReownAppKit? get appKit => _appKit;
  ReownAppKitModal? get appKitModal => _appKitModal;

  Future<void> initAppKitModal() async {
    // const iosOptions = IOSOptions(
    //   groupId: 'group.com.chat_blockchain_app.app', 
    //   accessibility: KeychainAccessibility.first_unlock,
    // );

    _appKit = await ReownAppKit.createInstance(
      logLevel: LogLevel.error,
      projectId: '8ceade25be555c3d49e4d184d7a90c02',
      metadata: const PairingMetadata(
        name: 'Example App',
        description: 'Example app description',
        url: 'https://example.com/',
        icons: ['https://example.com/logo.png'],
        redirect: Redirect(
          native: 'chat_blockchain_app://',
          universal: 'https://reown.com/chat_blockchain_app',
          linkMode: true|false,
        ),
      ),
    );

    // Creamos el modal
    _appKitModal = ReownAppKitModal(
      context: navigatorKey.currentContext!,
      appKit: _appKit!,
    );

    await _appKitModal!.init();
    print(_appKit);

    notifyListeners();

    _appKitModal!.onModalConnect.subscribe(_onModalEvent);
    _appKitModal!.onModalDisconnect.subscribe(_onModalEvent);
    notifyListeners();
  }

  void _onModalEvent(EventArgs? args) {
    // Cada vez que el modal conecte o desconecte, avisamos a la pantalla
    notifyListeners();
  }

  String? getAddress() {
    if (_appKitModal != null && _appKitModal!.isConnected) {
      final accounts = _appKitModal?.session?.getAccounts();
    
      if (accounts != null && accounts.isNotEmpty) {
        // Tomamos la primera cuenta y limpiamos el prefijo
        final fullAddress = accounts.first;
        return fullAddress.split(':').last; 
      }
    }
    return null;
  }

  Future<void> logout() async {
    if(_appKitModal?.isOpen ?? false) {
      _appKitModal?.closeModal();
    }
    await _appKitModal?.disconnect();
    notifyListeners();
  }

}