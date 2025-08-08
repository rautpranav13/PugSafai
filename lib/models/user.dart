class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String? roleId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'],
      roleId: json['role_id'],
    );
  }
}
