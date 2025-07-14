import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class FavoritoService {
  final String? _token = AuthService().token;

  Future<void> agregarFavorito(int libroId) async {
    if (_token == null) throw Exception('Token no disponible');

    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/favoritos/$libroId'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<void> eliminarFavorito(int libroId) async {
    if (_token == null) throw Exception('Token no disponible');

    await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/favoritos/$libroId'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<List<int>> obtenerFavoritos() async {
    if (_token == null) throw Exception('Token no disponible');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/favoritos'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<int>();
    } else {
      throw Exception('Error al cargar favoritos');
    }
  }
}
