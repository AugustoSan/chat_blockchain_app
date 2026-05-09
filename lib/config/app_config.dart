class AppConfig 
{
  static const String protocol = 'http';
  static const String apiBaseUrl = '192.168.1.70';
  static const String port = '5000';
  static const String wsUrl = 'ws://192.168.1.70:5000/ws';

  static const String loginPath = 'api/auth/login';

  static const String challengePath = 'api/User/challenge';
  static const String registerPublicKeyPath = 'api/User/registerPublicKey';
  static String getPublicKeyPath(String address) => 'api/User/validate/$address';
}
