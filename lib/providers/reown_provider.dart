import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:chat_blockchain_app/utils/keys.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'dart:convert';

class ReownProvider extends ChangeNotifier {
  IReownAppKit? _appKit;
  ReownAppKitModal? _appKitModal;

  IReownAppKit? get appKit => _appKit;
  ReownAppKitModal? get appKitModal => _appKitModal;

  // Declaración de la variable para App Links
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initAppKitModal() async {
    // const iosOptions = IOSOptions(
    //   groupId: 'group.com.chat_blockchain_app.app', 
    //   accessibility: KeychainAccessibility.first_unlock,
    // );

    try{
      const metadata = const PairingMetadata(
          name: 'Web3Message',
          description: 'App de mensajería Web3',
          url: 'https://augustosan.github.io/chat_blockchain_app/',
          icons: [],
          redirect: Redirect(
            native: 'chatblockchain://',
            universal: 'https://augustosan.github.io/chat_blockchain_app/',
            linkMode: true,
          ),
      );

      // _appKit = await ReownAppKit.createInstance(
      //   logLevel: LogLevel.error,
      //   projectId: '8ceade25be555c3d49e4d184d7a90c02',
      //   metadata: const PairingMetadata(
      //     name: 'Web3Message',
      //     description: 'App de mensajería Web3',
      //     url: 'https://augustosan.github.io/chat_blockchain_app/',
      //     icons: [],
      //     redirect: Redirect(
      //       native: 'chatblockchain://',
      //       universal: 'https://augustosan.github.io/chat_blockchain_app/',
      //       linkMode: true|false,
      //     ),
      //   ),
        
      // );

      // Creamos el modal
      _appKitModal = ReownAppKitModal(
        context: navigatorKey.currentContext!,
        enableAnalytics: true,
        projectId: '8ceade25be555c3d49e4d184d7a90c02',
        metadata: metadata,
        // siweConfig: SIWEConfig(...),
        // featuresConfig: FeaturesConfig(...),
        // getBalanceFallback: () async {},
        // customWallets: [
        //   ReownAppKitModalWalletInfo(
        //     listing: AppKitModalWalletListing(
        //       ...
        //     ),
        //   ),
        // ],
      );

      await _appKitModal!.init();
      print(_appKit);
      _appKit = _appKitModal!.appKit;
      notifyListeners();

      _appKitModal!.onModalConnect.subscribe(_onModalEvent);
      _appKitModal!.onModalDisconnect.subscribe(_onModalEvent);
      notifyListeners();

      // Inicializar la escucha de enlaces
      _initLinkListener();
      notifyListeners();
    }
    catch (e) {
      print("Error de AppKit modal: $e");
    }
  }

  void _initLinkListener() {
    // Cancelamos cualquier suscripción previa si existe
    _linkSubscription?.cancel();

    // Escuchamos todos los enlaces que entran a la app
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      final link = uri.toString();
      print("DEBUG: Enlace capturado: $link");

      // CRÍTICO: Pasamos el sobre (envelope) al AppKit para que resuelva la firma
      if (_appKitModal != null) {
        _appKitModal!.dispatchEnvelope(link);
      }
    }, onError: (err) {
      print("DEBUG: Error en AppLinks: $err");
    });
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

  ReownAppKitModalSession? getSession() {
    return _appKitModal?.session;
  }

  String? getTopic() {
    final session = _appKitModal?.session;
    if(session != null) {
      return session.topic;
    }
    return null;
  }

  Redirect? getRedirect() {
    final appKit = _appKitModal?.appKit;
    return appKit?.metadata.redirect;
  }

  Future<void> redirectToWallet(String topic, Redirect redirect) async {
    final appKit = _appKitModal?.appKit;
    await appKit?.redirectToWallet(topic: topic, redirect: redirect);
  }

  Future<String?> signatureMessage(String message) async {
    if (_appKitModal == null || !_appKitModal!.isConnected) {
      return null;
    }
    
    try {
      final session = _appKitModal?.session;
      if(session == null) throw Exception("Session is null");

      final String? fullAccount = session.getAccounts()?.first; // eip155:1:0x...
      if (fullAccount == null) return null;
      // final caip2ChainId = _appKitModal!.selectedChain?.chainId ?? 'eip155:1';
      final topic = session.topic;

      final bytes = utf8.encode(message);
      final encodedMessage = hex.encode(bytes);
      // final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(caip2ChainId);
      // final address = session.getAddress(namespace)!;

      final parts = fullAccount.split(':');
      final caip2ChainId = "${parts[0]}:${parts[1]}";
      final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(caip2ChainId);
      final address = session.getAddress(namespace)!;
      // final address = parts[2];

      if(topic == null) throw Exception("Topic is null");

      final result = await _appKitModal!.appKit?.request(
        topic: topic,
        chainId: caip2ChainId,
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [
            '0x$encodedMessage',
            address
          ],
        ),
      );
      if (result == null) return null;
      if (result is Map && result.containsKey('result')) {
        return result['result'].toString();
      }
      return result.toString();
    } catch (e) {
      print("Error firmando mensaje: $e");
      return null;
    }
  }

  String? getPublicKey() {
    if (_appKitModal != null && _appKitModal!.isConnected) {
      final session = _appKitModal?.session;

      if(session == null) throw Exception("Session is null");
      
      final accounts = session.getAccounts();

      if (accounts != null && accounts.isNotEmpty) {
        // Tomamos la primera cuenta y limpiamos el prefijo
        final fullAddress = accounts.first;
        final publicKey = fullAddress.split(':').last;
        return publicKey;
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

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

}