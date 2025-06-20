import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  final String email;

  const ResetPasswordScreen({required this.token, required this.email, Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _loading = false;

  void _resetPassword() async {
    setState(() => _loading = true);

    final response = await http.post(
      Uri.parse('http://tudominio.com/api/reset-password'), // <-- ajusta tu URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'token': widget.token,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
      }),
    );

    setState(() => _loading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Contraseña actualizada")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Error al actualizar la contraseña")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restablecer Contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Nueva Contraseña"),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: "Confirmar Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Actualizar Contraseña"),
            ),
          ],
        ),
      ),
    );
  }
}
