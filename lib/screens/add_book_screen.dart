import 'package:flutter/material.dart';
import '../../models/libro.dart';
import '../../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _anioController = TextEditingController();
  final _isbnController = TextEditingController();
  bool _disponible = true;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final libro = Libro(
        titulo: _tituloController.text,
        autor: _autorController.text,
        anioPublicacion: int.tryParse(_anioController.text) ?? 0,
        isbn: _isbnController.text,
        disponible: _disponible,
      );

      try {
        await BookService().agregarLibro(libro);
        if (context.mounted) {
          Navigator.pop(context, true); // Regresa a la lista con éxito
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar libro: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _anioController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Ingrese el título' : null,
              ),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (value) => value!.isEmpty ? 'Ingrese el autor' : null,
              ),
              TextFormField(
                controller: _anioController,
                decoration: const InputDecoration(labelText: 'Año de publicación'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el año de publicación' : null,
              ),
              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
                validator: (value) => value!.isEmpty ? 'Ingrese el ISBN' : null,
              ),
              SwitchListTile(
                title: const Text('¿Disponible?'),
                value: _disponible,
                onChanged: (value) {
                  setState(() {
                    _disponible = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar libro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
