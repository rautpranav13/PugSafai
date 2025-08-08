import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Janitor Login", style: TextStyle(fontSize: 24)),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                setState(() { _loading = true; _error = null; });
                bool success = await context.read<AuthProvider>().login(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
                setState(() { _loading = false; });
                if (success) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                } else {
                  setState(() { _error = "Invalid credentials"; });
                }
              },
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
              },
              child: const Text("No account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
