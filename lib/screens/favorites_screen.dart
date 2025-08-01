
import 'package:flutter/material.dart';
import '../services/favorito_service.dart';
import '../models/libro.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoriteService _favoriteService = FavoriteService();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Libro> favoritos = _favoriteService.getFavoritos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Libros Favoritos'),
      ),
      body: favoritos.isEmpty
          ? const Center(child: Text('No hay libros favoritos aún.'))
          : ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final libro = favoritos[index];
                return ListTile(
                  title: Text(libro.titulo),
                  subtitle: Text('${libro.autor} - ${libro.anioPublicacion}'),
                );
              },
            ),
    );
  }
}
