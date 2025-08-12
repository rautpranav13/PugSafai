import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pug_safai/models/cleaning_task.dart';
import 'package:pug_safai/models/location.dart';
import '../providers/auth_provider.dart';
import '../screens/dashboard_screen.dart'; // Assuming this path is correct

class ApiService {
  static const String _baseUrl = 'https://safai-index-backend.onrender.com/api';


  /// --- GET LOCATIONS API ---

  static Future<List<Location>> getLocations() async {
    final url = Uri.parse('$_baseUrl/locations');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body is List) {
          return body.map((json) => Location.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected API format for locations');
        }
      } else {
        throw Exception('Failed to load locations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getLocations: $e');
      throw Exception('Failed to fetch locations: $e');
    }
  }



  /// ----- Fetch Tasks for the User -----

  static Future<List<CleaningTask>> _fetchTasks(String userId) async {
    final url = Uri.parse('$_baseUrl/cleaner-reviews/$userId');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body['status'] == 'success' && body['data'] != null) {
          final List<dynamic> taskData = body['data'];
          // Map each item to CleaningTask model
          return taskData.map((json) => CleaningTask.fromMap(json)).toList();
        } else {
          throw Exception('Failed to load tasks: ${body['message']}');
        }
      } else {
        throw Exception('Failed to load tasks. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _fetchTasks: $e');
      throw Exception('Failed to connect to the server or parse data: $e');
    }
  }

  /// Public method to get tasks filtered by status
  static Future<List<CleaningTask>> getTasks(String userId, String taskStatus) async {
    final allTasks = await _fetchTasks(userId);
    return allTasks.where((task) => task.status.toLowerCase() == taskStatus.toLowerCase()).toList();
  }

  /// Get a single task by ID
  static Future<CleaningTask?> getTaskById(String userId, String taskId) async {
    final allTasks = await _fetchTasks(userId);
    try {
      return allTasks.firstWhere((task) => task.id == taskId);
    } catch (_) {
      return null;
    }
  }



  /// ---------------- REGISTER USER ----------------

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




  /// ---------------- LOGIN USER ----------------

  static Future<Map<String, dynamic>> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    return jsonDecode(response.body);
  }



  /// ---------------- POST START TASK ----------------

  static Future<Map<String, dynamic>> postStartTask({
    required BuildContext context,
    required String address,
    required String siteId,
    required String initialComment,
    required List<File> beforePhotos, // still keeping parameter for now
  }) async {
    try {
      // Get logged in user details
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final uri = Uri.parse('$_baseUrl/cleaner-reviews');

      // Hardcoded before_photo list (instead of uploading files)
      final beforePhotoList = [
        "images-sample1.jpg",
        "images-sample2.jpg"
      ];

      // Prepare normal POST request (application/json)
      final body = jsonEncode({
        "name": user.name,
        "phone": user.phone,
        "cleaner_user_id": user.id, // id is String
        "address": address,
        "site_id": siteId,
        "created_at": DateTime.now().toUtc().toIso8601String(),
        "initial_comment": initialComment,
        //"before_photo": beforePhotoList,
        "status": "ongoing",
      });

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to start task. Status: ${response.statusCode} Body: ${response.body}');
      }
    } catch (e) {
      print('Error in postStartTask: $e');
      throw Exception('Error starting task: $e');
    }
  }

}
