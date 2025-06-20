import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.135.21:8000/api';

  // ✅ Login
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/user/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        if (data['access_token'] != null && data['user'] != null) {
          await prefs.setString('token', data['access_token']);
          await prefs.setString(
              'user_name', data['user']['name'] ?? 'Invitado');
          await prefs.setString('user_email', data['user']['email'] ?? '');
          await prefs.setString('user_role', data['user']['role'] ?? 'Cliente');
          return true;
        } else {
          print('⚠️ Login sin token o user');
          return false;
        }
      } else {
        print('❌ Error login: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Excepción login: $e');
      return false;
    }
  }

  // ✅ Registro
  static Future<bool> register({
    required String firstName,  // 👈 Este es el nombre correcto
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/user/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        final user = data['user'];
        final token = data['access_token'];

        if (token != null && user != null) {
          await prefs.setString('token', token);
          await prefs.setString('user_firstName', user['firstName'] ?? '');
          await prefs.setString('user_lastName', user['lastName'] ?? '');
          await prefs.setString('user_email', user['email'] ?? '');
          await prefs.setString('user_role', user['role'] ?? 'Cliente');
          return true;
        } else {
          print('⚠️ Registro sin token o sin datos de usuario');
          return false;
        }
      } else {
        print('❌ Registro fallido: ${response.statusCode}');
        print('🔍 Detalles: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Excepción en el registro: $e');
      return false;
    }
  }
// Obtener datos del perfil del usuario
static Future<Map<String, dynamic>?> obtenerPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/auth/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('❌ Error: ${response.statusCode}');
      return null;
    }
  }


  // ✅ Actualizar perfil
 static Future<bool> actualizarPerfil({
  required String firstName,
  required String lastName,
  required String phone,
  String? password,
  String? confirmPassword,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) return false;

  final Map<String, dynamic> body = {
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
  };

  if (password != null && password.isNotEmpty) {
    body['password'] = password;
    body['password_confirmation'] = confirmPassword ?? '';
  }

  final response = await http.put(
    Uri.parse('$baseUrl/user/update'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  return response.statusCode == 200;
}
//Recuperación de contraseña
static Future<bool> recuperarContrasena(String email) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/user/recuperar-password'), // Ajusta a tu URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    return response.statusCode == 200;
  } catch (e) {
    print('Error en recuperar contraseña: $e');
    return false;
  }
}
}
