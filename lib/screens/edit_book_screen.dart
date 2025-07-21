import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/book_service.dart';

class EditBookScreen extends StatefulWidget {
  final Libro libro;

  const EditBookScreen({super.key, required this.libro});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _anioController;
  late TextEditingController _isbnController;
  bool disponible = true;

  final BookService _bookService = BookService();

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.libro.titulo);
    _autorController = TextEditingController(text: widget.libro.autor);
    _anioController = TextEditingController(text: widget.libro.anioPublicacion.toString());
    _isbnController = TextEditingController(text: widget.libro.isbn);
    disponible = widget.libro.disponible;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _anioController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      try {
        final camposActualizados = {
          "titulo": _tituloController.text,
          "autor": _autorController.text,
          "anioPublicacion": int.tryParse(_anioController.text) ?? 0,
          "isbn": _isbnController.text,
          "disponible": disponible,
        };

        await _bookService.actualizarLibroParcial(widget.libro.id!, camposActualizados);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el libro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Ingrese un título' : null,
              ),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (value) => value!.isEmpty ? 'Ingrese un autor' : null,
              ),
              TextFormField(
                controller: _anioController,
                decoration: const InputDecoration(labelText: 'Año de Publicación'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
              ),
              SwitchListTile(
                title: const Text('Disponible'),
                value: disponible,
                onChanged: (value) {
                  setState(() {
                    disponible = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
