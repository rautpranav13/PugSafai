import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _roleIdController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) => val == null || val.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 10),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) => val == null || val.isEmpty ? "Enter email" : null,
              ),
              const SizedBox(height: 10),

              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (val) => val == null || val.isEmpty ? "Enter phone number" : null,
              ),
              const SizedBox(height: 10),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (val) => val != null && val.length < 6 ? "Min 6 chars" : null,
              ),
              const SizedBox(height: 10),

              // Age
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // RoleID
              TextFormField(
                controller: _roleIdController,
                decoration: const InputDecoration(labelText: "Role ID"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),

              // Register button
              ElevatedButton(
                  onPressed: _loading ? null : () async {
                    if (!_formKey.currentState!.validate()) return;

                    setState(() {
                      _loading = true;
                      _error = null;
                    });

                    try {
                      bool success = await context.read<AuthProvider>().register(
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                        _phoneController.text.trim(),
                        _passwordController.text.trim(),
                        age: _ageController.text.isNotEmpty
                            ? int.tryParse(_ageController.text)
                            : null,
                        roleId: _roleIdController.text.isNotEmpty
                            ? int.tryParse(_roleIdController.text)
                            : null,
                      );

                      setState(() => _loading = false);

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      }
                    } catch (e) {
                      setState(() {
                        _loading = false;
                        _error = e.toString().replaceAll("Exception: ", "");
                      });
                    }
                  },
                  child: const Text('Register'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
