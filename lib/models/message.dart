class Message {
  final String from;
  final String to;
  final DateTime timestamp;
  final String text;
  late String? authTag;
  late String? encryptedKey;
  late String? iv;

  Message({required this.from, required this.to, required this.text, required this.timestamp, required this.encryptedKey, required this.iv, required this.authTag});
  Message.withRequired({required this.from, required this.to, required this.timestamp, required this.text, this.authTag, this.encryptedKey, this.iv});

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      // Solo se incluirán en el JSON si no son nulos
      if (encryptedKey != null) 'encryptedKey': encryptedKey,
      if (iv != null) 'iv': iv,
      if (authTag != null) 'authTag': authTag,
    };
  }
}