
import 'package:flutter/material.dart';
import '../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  bool _disponible = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _submitForm() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await BookService.agregarLibro(
        titulo: _tituloController.text,
        autor: _autorController.text,
        anioPublicacion: int.tryParse(_anioController.text) ?? 0,
        isbn: _isbnController.text,
        disponible: _disponible,
      );

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                value: _disponible,
                onChanged: (value) {
                  setState(() {
                    _disponible = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  child: const Text('Agregar Libro'),
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
