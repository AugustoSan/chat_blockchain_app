import 'package:flutter/services.dart';
import 'package:reown_appkit/modal/appkit_modal_impl.dart';
// import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';

class DeepLinkHandler {
  static const _eventChannel = EventChannel('chat_blockchain_app/events');
  static const _methodChannel = MethodChannel('chat_blockchain_app/methods');
  static late ReownAppKitModal _appKitModal;

  static void initEventChannel() {
    try {
      _eventChannel.receiveBroadcastStream().listen(_onLink, onError: _onError);
    } catch (e) {
      print(e);
    }
  }

  static void initMethodChannel(ReownAppKitModal appKitModal) {
    _appKitModal = appKitModal;
  }

  static void checkInitialLink() async {
    try {
      _methodChannel.invokeMethod('initialLink');
    } catch (e) {
      print(e);
    }
  }

  static void _onLink(dynamic link) async {
    try {
      _appKitModal.dispatchEnvelope(link);
      print(link);
    } catch (e) {
      print(e);
    }
  }

  static void _onError(dynamic e) {
    print(e);
  }
}