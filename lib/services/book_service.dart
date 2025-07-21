import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/libro.dart';

class BookService {
  final String baseUrl = 'http://192.168.10.194:8080/api/libros';

  Future<List<Libro>> obtenerLibros() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => Libro.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener libros');
    }
  }

  Future<Libro> agregarLibro(Libro libro) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(libro.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Libro.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al agregar libro: ${response.statusCode}');
    }
  }

  Future<void> eliminarLibro(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar libro');
    }
  }

  Future<Libro> actualizarLibroParcial(int id, Map<String, dynamic> campos) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(campos),
    );

    if (response.statusCode == 200) {
      return Libro.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar libro');
    }
  }
}
