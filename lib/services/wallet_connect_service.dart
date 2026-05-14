// import 'dart:convert';

// import 'package:chat_blockchain_app/services/secure_storage.dart';
// import 'package:ensemble_walletconnect/ensemble_walletconnect.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class WalletConnectService {
//   late WalletConnect connector;

//   void initConnector() {
//     connector = WalletConnect(
//       bridge: 'https://bridge.walletconnect.org',
//       clientMeta: PeerMeta(
//         name: 'CipherChat',
//         description: 'App de mensajeria basada en identidad blockchain',
//         url: 'https://cipherchat.com',
//         icons: ['https://cipherchat.com/icon.png']
//       )
//     );
//   }

//   // Inicia la conexión
//   Future<void> connect(BuildContext context) async {
//     if (!connector.connected) {
//       await connector.createSession(
//         chainId: 1, // 1 = Ethereum Mainnet. Cambia según la red que uses
//         onDisplayUri: (uri) {
//           // Muestra el QR en un diálogo
//           showDialog(
//             context: context,
//             builder: (context) => Dialog(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text('Escanea el código QR con tu wallet'),
//                     const SizedBox(height: 16),
//                     QrImageView(
//                       data: uri,
//                       size: 200.0,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     }

//     // Eventos de la conexión
//     connector.on('connect', (session) {
//       print(session);
//       if(session != null) {
//         SecureStorage.saveSession(session);
//       }
//     });

//     connector.on('disconnect', (session) {
//       print('Sesión desconectada');
//     });
//   }

//   Future<void> getSession(String session) async {
//     final sessionJson = await SecureStorage.getSession();
//     if(sessionJson != null) {
//       final session = jsonDecode(sessionJson);
//       initConnector();

//       connector.updateSession(session);
//     }
//   }
// }