import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:chat_blockchain_app/EventChannel/deep_link_handler.dart';
// import 'package:chat_blockchain_app/services/api_service.dart';
import 'package:chat_blockchain_app/utils/keys.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
// import 'package:reown_appkit/modal/services/magic_service/models/frame_message.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'dart:convert';

class ReownProvider extends ChangeNotifier {
  ReownAppKitModal? _appKitModal;
  bool _isInitialized = false;


  ReownAppKitModal? get appKitModal => _appKitModal;
  bool get isConnected => _appKitModal?.isConnected ?? false;

  // Declaración de la variable para App Links
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;


  Future<void> initAppKitModal() async {

    if(_isInitialized) return;
    await Future.delayed(const Duration(milliseconds: 500));
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

      // final siweConfig = SIWEConfig(
      //   getNonce: () async {
      //     return SIWEUtils.generateNonce();
      //   },
      //   getMessageParams: () async {
      //     final address = SIWEUtils.getAddressFromMessage(args.message);
      //     // 1. Obtén un nonce único desde tu backend
      //     final nonce = await _apiService.getChallenge(address);
      //     return SIWECreateMessageArgs(
      //       domain: 'tudominio.com',
      //       uri: Uri.parse('https://tudominio.com'),
      //       chains: [1], // Mainnet
      //       statement: 'Inicia sesión con tu wallet de Ethereum',
      //       nonce: nonce,
      //     );
      //   }, 
      //   createMessage: (SIWECreateMessageArgs args) {
      //     return SIWEUtils.formatMessage(args);
      //   }, 
      //   verifyMessage: (SIWEVerifyMessageArgs args) async {
      //     final chainId = SIWEUtils.getChainIdFromMessage(args.message);
      //     final address = SIWEUtils.getAddressFromMessage(args.message);
      //     final cacaoSignature = args.cacao != null
      //         ? args.cacao!.s
      //         : CacaoSignature(
      //             t: CacaoSignature.EIP191,
      //             s: args.signature,
      //           );
      //     return await SIWEUtils.verifySignature(
      //       address,
      //       args.message,
      //       cacaoSignature,
      //       chainId,
      //       DartDefines.projectId,
      //     );
      //   }, 
      //   getSession: () async {
      //     final chainSelected = _appKitModal!.selectedChain;
      //     final chainId = chainSelected?.chainId ?? '1';
      //     final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(
      //       chainId,
      //     );
      //     final address = _appKitModal!.session!.getAddress(namespace)!;
      //     return SIWESession(address: address, chains: [chainId]);
      //   },
      //   signOut: () async {
      //     return true;
      //   },
      // );

      // Creamos el modal
      final appKit = ReownAppKitModal(
        context: navigatorKey.currentContext!,
        enableAnalytics: true,
        projectId: '8ceade25be555c3d49e4d184d7a90c02',
        metadata: metadata,
      );

      await appKit.init();
      _appKitModal = appKit;
      DeepLinkHandler.initMethodChannel(appKit);
      _isInitialized = true;

      // Escuchar cambios en la conexión
      appKit.addListener(() {
        notifyListeners();
      });

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
        else {
        print("⚠️ _appKitModal es nulo, no se puede entregar el envelope.");
        // Opcional: Guardar el link para procesarlo cuando el modal esté listo.
      }
    }, onError: (err) {
      print("DEBUG: Error en AppLinks: $err");
    });
  }

  // void _onModalEvent(EventArgs? args) {
  //   // Cada vez que el modal conecte o desconecte, avisamos a la pantalla
  //   notifyListeners();
  // }

  // Future<bool> isConnected() async {
  //   if (appKitModal == null || !appKitModal!.isConnected) return false;
  //   return appKitModal!.isConnected;
  // }

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

  // Future<void> requestAccounts() async {
  //   if (appKitModal == null || !appKitModal!.isConnected) return;
    
  //   final session = appKitModal!.session;
  //   if(session == null) return;
  //   final topic = session.topic;

  //   final String? fullAccount = session.getAccounts()?.first; // eip155:1:0x...
  //   if (fullAccount == null) return null;
    
  //   final parts = fullAccount.split(':');
  //   final caip2ChainId = "${parts[0]}:${parts[1]}";
    
  //   try {
  //     await appKitModal!.request(
  //       topic: topic,
  //       chainId: caip2ChainId,
  //       request: SessionRequestParams(
  //         method: 'eth_requestAccounts',
  //         params: [],
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error en eth_requestAccounts: $e');
  //     rethrow;
  //   }
  // }

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

  // "Despertar" wallet (opcional pero recomendado)
  // Future<void> wakeUpWallet() async {
  //   if (_appKitModal == null || !isConnected) return;
  //   try {
  //     await _appKitModal!.request(
  //       topic: _appKitModal!.session!.topic,
  //       chainId: _appKitModal!.session!.chainId,
  //       request: SessionRequestParams(
  //         method: 'eth_requestAccounts',
  //         params: [],
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint('Wake up error: $e');
  //   }
  // }

  Future<String?> signMessage(String message) async {
    if (_appKitModal == null || !_appKitModal!.isConnected) {
      print("❌ signMessage: AppKit no disponible o no conectado");
      return null;
    }
    
    try {
      final session = _appKitModal?.session;
      if (session == null) {
        print("❌ signMessage: session es null");
        return null;
      }

      final String? fullAccount = session.getAccounts()?.first; // eip155:1:0x...
      if (fullAccount == null) {
        print("❌ signMessage: No hay cuentas en la sesión");
        return null;
      }
      final topic = session.topic;

      final bytes = utf8.encode(message);
      final encodedMessage = '0x${hex.encode(bytes)}';

      final parts = fullAccount.split(':');
      final caip2ChainId = "${parts[0]}:${parts[1]}";
      final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(caip2ChainId);
      final address = session.getAddress(namespace)!;

      if(topic == null) throw Exception("Topic is null");

      print("🔐 Solicitando firma para address: $address");
      print("📝 Mensaje (hex): $encodedMessage");

      final signature = await _appKitModal!.request(
        topic: topic,
        chainId: caip2ChainId,
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [
            encodedMessage,
            address
          ],
        ),
      );


      // final signature = await _signatureCompleter!.future.timeout(
      //   const Duration(minutes: 2),
      //   onTimeout: () => throw Exception("Timeout: No se recibió la firma"),
      // );
      if (signature == null) return null;
      // if (signature is Map && signature.containsKey('signature')) {
      //   return signature['result'].toString();
      // }
      // print("✅ Firma recibida: $signature");
      return signature;
    } catch (e) {
      print("❌ Error en signMessage: $e");
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

  // Este método lo llamarás desde el listener del deep link
  // void handleDeepLink(String uri) {
  //   print("🔗 Deep link recibido: $uri");
    
  //   // Si no hay firma pendiente, ignoramos
  //   if (_signatureCompleter == null) {
  //     print("⚠️ No hay firma pendiente");
  //     return;
  //   }
    
  //   // Intenta extraer la firma del URI (depende del formato de Reown)
  //   // Normalmente el envelope contiene la respuesta en formato JSON.
  //   // Por simplicidad, usaremos dispatchEnvelope y esperaremos un evento.
  //   // Pero como no funciona, haremos un parseo básico.
    
  //   // Opción A: Delegar al SDK (intentamos de nuevo)
  //   _appKitModal?.dispatchEnvelope(uri);
    
  //   // Opción B: Forzar resolución manual (si conoces la estructura del envelope)
  //   // Ejemplo teórico: chatblockchain://wc?sessionId=xxx&signature=0x123...
  //   // Pero el formato real es más complejo. Mejor usar el evento del modal.
  // }

  // Método para que el modal notifique la respuesta (usando su propio listener)
  // void _onModalResponse(dynamic response) {
  //   if (_signatureCompleter != null && !_signatureCompleter!.isCompleted) {
  //     // Asume que 'response' contiene la firma
  //     final signature = response.toString();
  //     _signatureCompleter!.complete(signature);
  //   }
  // }


  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

}