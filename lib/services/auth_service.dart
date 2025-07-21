import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const _storage = FlutterSecureStorage(); // 🔐 Almacenamiento seguro

  String? _token;
  String? _rol;
  String? _usuarioId;

  String? get token => _token;
  String? get rol => _rol;
  String? get usuarioId => _usuarioId;

  final String baseUrl = 'http://192.168.10.194:8080/api/auth';

  Future<bool> register({
    required String nombre,
    required int edad,
    required String email,
    required String password,
    required String direccion,
    required String telefono,
    required String rol,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'edad': edad,
          'email': email,
          'password': password,
          'direccion': direccion,
          'telefono': telefono,
          'rol': rol,
        }),
      );

      print('🔁 REGISTER STATUS: ${response.statusCode}');
      print('📩 REGISTER RESPONSE: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ ERROR EN REGISTRO: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('🔐 LOGIN STATUS: ${response.statusCode}');
      print('📩 LOGIN RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _rol = data['rol'];
        _usuarioId = data['id'].toString(); // ← Asegúrate que el backend devuelva 'id'

        // 🔐 Guardar token, rol e ID en almacenamiento seguro
        await _storage.write(key: 'token', value: _token);
        await _storage.write(key: 'rol', value: _rol);
        await _storage.write(key: 'usuarioId', value: _usuarioId);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('❌ ERROR EN LOGIN: $e');
      return false;
    }
  }

  void logout() async {
    _token = null;
    _rol = null;
    _usuarioId = null;
    await _storage.deleteAll(); // 🔐 Borrar datos del almacenamiento seguro
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<String?> getRol() async {
    return await _storage.read(key: 'rol');
  }

  static Future<String?> getUsuarioId() async {
    return await _storage.read(key: 'usuarioId');
  }
}
