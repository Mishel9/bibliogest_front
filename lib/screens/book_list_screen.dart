import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/book_service.dart';
import 'add_book_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Libro> libros = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLibros();
  }

  Future<void> fetchLibros() async {
    try {
      final fetchedLibros = await BookService.fetchBooks();
      setState(() {
        libros = fetchedLibros;
        isLoading = false;
      });
    } catch (e) {
      print('Error al obtener libros: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los libros')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Libros')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : libros.isEmpty
              ? const Center(child: Text('No hay libros disponibles'))
              : ListView.builder(
                  itemCount: libros.length,
                  itemBuilder: (context, index) {
                    final libro = libros[index];
                    return ListTile(
                      title: Text(libro.titulo),
                      subtitle: Text('Autor: ${libro.autor}'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
          if (result == true) {
            fetchLibros();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Agregar libro',
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
