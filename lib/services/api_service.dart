import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = "https://safai-index-backend.onrender.com/api";

  /// Register new user
  static Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    int? age,
    int? roleId,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    final Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "age": age,
      "role_id": roleId
    };

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("REGISTER STATUS: ${res.statusCode}");
    print("REGISTER RESPONSE: ${res.body}");

    return res.statusCode == 200;
  }

  /// Login user
  static Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");
    final body = {
      "email": email,
      "password": password,
    };

    final res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final user = User.fromJson(data["user"]);
      // store locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", user.id);
      await prefs.setString("name", user.name);
      await prefs.setString("email", user.email);
      return user;
    }
    return null;
  }
}
