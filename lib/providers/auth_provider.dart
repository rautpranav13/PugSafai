import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<bool> login(String email, String password) async {
    _user = await ApiService.loginUser(email: email, password: password);
    notifyListeners();
    return _user != null;
  }

  Future<bool> register(
      String name,
      String email,
      String phone,
      String password, {
        int? age,
        int? roleId,
      }) async {
    try {
      return await ApiService.registerUser(
        name: name,
        email: email,
        phone: phone,
        password: password,
        age: age,
        roleId: roleId,
      );
    } catch (e) {
      throw e; // Pass error to UI
    }
  }


  void logout() {
    _user = null;
    notifyListeners();
  }
}
