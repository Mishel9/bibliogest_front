import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/libro.dart';
import '../services/auth_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Libro>> _favoriteBooks;

  @override
  void initState() {
    super.initState();
    _favoriteBooks = fetchFavoriteBooks();
  }

  Future<List<Libro>> fetchFavoriteBooks() async {
    final token = await AuthService.getToken(); // ✅ Usar método correcto
    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await http.get(
      Uri.parse('http://192.168.10.194:8080/api/favoritos'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Libro.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar libros favoritos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Libro>>(
        future: _favoriteBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes libros favoritos.'));
          }

          final libros = snapshot.data!;

          return ListView.builder(
            itemCount: libros.length,
            itemBuilder: (context, index) {
              final libro = libros[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.redAccent),
                  title: Text(libro.titulo),
                  subtitle: Text(libro.autor),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
