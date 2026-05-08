import 'package:dio/dio.dart';
// import 'package:chat_blockchain_app/services/secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.3.47:5000'; // Cambiar según tu IP/túnel
  final Dio _dio = Dio();

  Future<String> getChallenge(String address) async {
    final response = await _dio.post('$baseUrl/api/auth/challenge',
        data: {'address': address});
    return response.data['challenge'];
  }

  Future<Map<String, String>> login(String address, String signature, String originalChallenge) async {
    final response = await _dio.post('$baseUrl/api/auth/login',
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
    await _dio.post('$baseUrl/api/auth/registerPublicKey',
        options: Options(headers: {'Authorization': 'Bearer $jwt'}),
        data: {'publicKeyHex': publicKeyHex});
  }

  Future<String> getPublicKey(String jwt, String address) async {
    final response = await _dio.get('$baseUrl/api/auth/publicKey/$address',
        options: Options(headers: {'Authorization': 'Bearer $jwt'}));
    return response.data['publicKey'];
  }
}