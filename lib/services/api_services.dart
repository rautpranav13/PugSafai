import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://safai-index-backend.onrender.com/api';

  static Future<Map<String, dynamic>> register(String name, String email, String phone, String password, int age) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "age": age,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
     return jsonDecode(response.body);
  }
}
