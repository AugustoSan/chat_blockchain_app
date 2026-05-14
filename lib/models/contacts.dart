class Contact {
  final String id;
  final String publickey;
  final String address;
  final String username;

  Contact({
    required this.id,
    required this.publickey,
    required this.address,
    required this.username,
  });

  String get publicKey => publickey;

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      publickey: json['publicKey'] ?? '',
      address: json['address'] ?? '',
      username: json['username'] ?? '' ,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'publicKey': publickey,
      'address': address,
      'username': username,
    };
  }
}