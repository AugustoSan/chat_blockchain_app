import 'package:chat_blockchain_app/config/app_config.dart';
import 'package:dio/dio.dart';
// import 'package:chat_blockchain_app/services/secure_storage.dart';

class ApiService {
  static const String baseUrl = '${AppConfig.protocol}://${AppConfig.apiBaseUrl}:${AppConfig.port}'; // Cambiar según tu IP/túnel
  final Dio _dio = Dio();

  Future<String> getChallenge(String address) async {
    final response = await _dio.post('$baseUrl/${AppConfig.challengePath}',
        data: {'address': address});
    return response.data['challenge'];
  }

  Future<Map<String, String>> login(String address, String signature, String originalChallenge) async {
    final response = await _dio.post('$baseUrl/${AppConfig.loginPath}',
        data: {
          'address': address,
          'signature': signature,
          'originalChallenge': originalChallenge
        });
    return {
      'token': response.data['token'],
      'address': response.data['address'],
    };
  }

  Future<void> registerPublicKey(String jwt, String publicKeyHex) async {
    await _dio.post('$baseUrl/${AppConfig.registerPublicKeyPath}',
        options: Options(headers: {'Authorization': 'Bearer $jwt'}),
        data: {'publicKeyHex': publicKeyHex});
  }

  Future<String> getPublicKey(String jwt, String address) async {
    final response = await _dio.get('$baseUrl/${AppConfig.getPublicKeyPath(address)}',
        options: Options(headers: {'Authorization': 'Bearer $jwt'}));
    return response.data['publicKey'];
  }
}