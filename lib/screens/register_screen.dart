import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String nombre = '';
  String apellido = '';
  String correo = '';
  String contrasena = '';
  String confirmar = '';

  bool _loading = false;

  void _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final success = await AuthService.register(
      firstName: nombre,
      lastName: apellido,
      email: correo,
      password: contrasena,
      confirmPassword: confirmar,
    );

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '✅ Registro exitoso' : '❌ Error al registrar. Intenta nuevamente.'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 141, 1, 255)),
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[900],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromARGB(255, 141, 1, 255)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Crear Cuenta', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                '¡Bienvenido!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Regístrate para comenzar',
                style: TextStyle(fontSize: 16, color: Colors.white60),
              ),
              const SizedBox(height: 40),

              TextFormField(
                decoration: _buildInputDecoration('Nombre', Icons.person),
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                onChanged: (value) => nombre = value,
                validator: (value) => value == null || value.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: _buildInputDecoration('Apellido', Icons.person_outline),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => apellido = value,
                validator: (value) => value == null || value.isEmpty ? 'Ingresa tu apellido' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: _buildInputDecoration('Correo', Icons.email),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => correo = value,
                validator: (value) => value == null || !value.contains('@') ? 'Correo no válido' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: _buildInputDecoration('Contraseña', Icons.lock),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (value) => contrasena = value,
                validator: (value) => value == null || value.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: _buildInputDecoration('Confirmar contraseña', Icons.lock_outline),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (value) => confirmar = value,
                validator: (value) => value != contrasena ? 'Las contraseñas no coinciden' : null,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _registrarUsuario,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_circle),
                  label: const Text('Registrarse', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 157, 4, 234),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
