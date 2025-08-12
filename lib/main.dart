import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pug_safai/screens/complete_task_screen.dart';
import 'package:pug_safai/screens/dashboard_screen.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Pug Safai',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.user != null) {
          return CompleteTaskScreen(taskId: '3',);
        } else {
          return CompleteTaskScreen(taskId: '3',);
        }
      },
    );
  }
}
