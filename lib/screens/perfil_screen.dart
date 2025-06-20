import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import './login_screen.dart';
import './home_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController  = TextEditingController();
  final TextEditingController _emailController     = TextEditingController();
  final TextEditingController _phoneController     = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final data = await AuthService.obtenerPerfil();
    setState(() {
      if (data != null) {
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text  = data['lastName']  ?? '';
        _emailController.text     = data['email']     ?? '';
        _phoneController.text     = data['phone']     ?? '';
      }
      _loading = false;
    });
  }

  Future<void> _guardarCambios() async {
    if (_passwordController.text.trim().isNotEmpty &&
        _passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    final success = await AuthService.actualizarPerfil(
      firstName: _firstNameController.text.trim(),
      lastName : _lastNameController.text.trim(),
      phone    : _phoneController.text.trim(),
      password : _passwordController.text.trim().isNotEmpty
          ? _passwordController.text.trim()
          : null,
      confirmPassword: _confirmPasswordController.text.trim().isNotEmpty
          ? _confirmPasswordController.text.trim()
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '✅ Perfil actualizado' : '❌ Error al guardar'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  // Estilo idéntico al usado en register_screen.dart
  InputDecoration _dec(String label, IconData ic) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(ic, color: Colors.purpleAccent),
        filled: true,
        fillColor: Colors.grey[900],
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.purpleAccent),
        ),
      );

  Widget _field(String label, IconData icon, TextEditingController c,
      {bool enabled = true, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: c,
        enabled: enabled,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: _dec(label, icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Icon(Icons.person, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field('Nombre', Icons.person, _firstNameController),
                    _field('Apellido', Icons.person_outline, _lastNameController),
                    _field('Correo', Icons.email, _emailController, enabled: false),
                    _field('Teléfono', Icons.phone, _phoneController),
                    _field('Contraseña nueva', Icons.lock, _passwordController,
                        obscure: true),
                    _field('Confirmar contraseña', Icons.lock_outline,
                        _confirmPasswordController,
                        obscure: true),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _guardarCambios,
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Cambios'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
