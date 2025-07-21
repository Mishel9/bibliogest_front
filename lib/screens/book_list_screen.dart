import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/book_service.dart';
import '../services/favorito_service.dart';
import 'edit_book_screen.dart';
import 'add_book_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  final FavoriteService _favoriteService = FavoriteService();
  List<Libro> _libros = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLibros();
  }

  Future<void> _fetchLibros() async {
    try {
      final libros = await _bookService.obtenerLibros();
      setState(() {
        _libros = libros;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar libros: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _editarLibro(Libro libro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookScreen(libro: libro),
      ),
    ).then((_) => _fetchLibros());
  }

  void _agregarLibro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBookScreen()),
    ).then((_) => _fetchLibros());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Libros'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _libros.length,
              itemBuilder: (context, index) {
                final libro = _libros[index];
                final esFavorito = _favoriteService.esFavorito(libro);

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  child: ListTile(
                    title: Text(libro.titulo),
                    subtitle:
                        Text('${libro.autor} - ${libro.anioPublicacion}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarLibro(libro),
                        ),
                        IconButton(
                          icon: Icon(
                            esFavorito
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.pink,
                          ),
                          onPressed: () {
                            setState(() {
                              if (esFavorito) {
                                _favoriteService.eliminarDeFavoritos(libro);
                              } else {
                                _favoriteService.agregarAFavoritos(libro);
                              }
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  esFavorito
                                      ? 'Eliminado de favoritos'
                                      : 'Agregado a favoritos',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarLibro,
        child: const Icon(Icons.add),
      ),
    );
  }
}
