import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/libro.dart';

class BookService {
  static const String _baseUrl = 'http://192.168.10.194:8080/api/libros';

  // ✅ Agregar libro SIN token
  static Future<void> agregarLibro({
    required String titulo,
    required String autor,
    required int anioPublicacion,
    required String isbn,
    required bool disponible,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'titulo': titulo,
        'autor': autor,
        'anioPublicacion': anioPublicacion,
        'isbn': isbn,
        'disponible': disponible,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al agregar libro: ${response.body}');
    }
  }

  // 📚 Obtener lista de libros (requiere token si backend lo exige)
  static Future<List<Libro>> fetchBooks() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Libro.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener libros: ${response.body}');
    }
  }
}
