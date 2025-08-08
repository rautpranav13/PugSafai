import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_services.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> register(String name, String email, String phone, String password, int age) async {
    final response = await ApiService.register(name, email, phone, password, age);
    print(response);
    if (response.containsKey('userId')) {
      // Automatically log in the user after registration
      await login(phone, password);
    } else {
      throw Exception(response['message']);
    }
  }

  Future<void> login(String phone, String password) async {
    final response = await ApiService.login(phone, password);
    if (response.containsKey('user')) {
      _user = User.fromJson(response['user']);
      notifyListeners();
    } else {
      throw Exception(response['message']);
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
