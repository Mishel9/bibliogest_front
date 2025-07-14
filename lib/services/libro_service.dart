import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/libro.dart';
import 'auth_service.dart';

class BookService {
  final String baseUrl = 'http://192.168.10.194:8080/api/libros';

  Future<bool> agregarLibro(Libro book) async {
    final token = AuthService().token;

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(book.toJson()),
    );

    return response.statusCode == 200;
  }
}
