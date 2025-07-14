import 'package:flutter/material.dart';
import '../models/libro.dart';

class LibroCard extends StatelessWidget {
  final Libro libro;

  const LibroCard({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(libro.titulo),
        subtitle: Text(libro.autor),
      ),
    );
  }
}
