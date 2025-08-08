// lib/models/user.dart

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final int? roleId; // Can be null based on the response

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    this.roleId,
  });

  /// Creates a User instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] is int ? json['age'] : int.tryParse(json['age'].toString()) ?? 0,
      roleId: json['role_id'] is int ? json['role_id'] : null,
    );
  }
}