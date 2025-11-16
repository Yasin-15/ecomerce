class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      avatar: json['avatar'] ?? 'https://via.placeholder.com/150',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'avatar': avatar,
    };
  }
}
