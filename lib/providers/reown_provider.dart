import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reown_appkit/reown_appkit.dart';

class ReownProvider extends ChangeNotifier {
  ReownAppKit? _appKit;
  ReownAppKitModal? _appKitModal;

  ReownAppKit? get appKit => _appKit;
  ReownAppKitModal? get appKitModal => _appKitModal;

  Future<void> initAppKitModal(BuildContext context) async {
    // const iosOptions = IOSOptions(
    //   groupId: 'group.com.chat_blockchain_app.app', 
    //   accessibility: KeychainAccessibility.first_unlock,
    // );
    _appKit = await ReownAppKit.createInstance(
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
      context: context,
      appKit: _appKit!,
    );

    await _appKitModal!.init();
    print(_appKit);

    notifyListeners();
  }

}