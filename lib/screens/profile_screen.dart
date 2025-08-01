import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bibliogestapp/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> prestamos = [];

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController tituloController = TextEditingController();

  DateTime? _fechaPrestamo;
  DateTime? _fechaDevolucion;

  @override
  void initState() {
    super.initState();
    obtenerPrestamos();
  }

  Future<void> obtenerPrestamos() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.10.194:8080/api/prestamos'),
      );

      if (response.statusCode == 200) {
        setState(() {
          prestamos = json.decode(response.body);
        });
      } else {
        print('Error al obtener préstamos: ${response.body}');
      }
    } catch (e) {
      print('Error de red: $e');
    }
  }

  Future<void> registrarPrestamoManual(
    String nombre,
    String libro, {
    DateTime? fechaPrestamo,
    DateTime? fechaDevolucion,
  }) async {
    final response = await http.post(
      Uri.parse('http://192.168.10.194:8080/api/prestamos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': nombre,
        'libro': libro,
        if (fechaPrestamo != null)
          'fechaPrestamo': fechaPrestamo.toIso8601String().split('T')[0],
        if (fechaDevolucion != null)
          'fechaDevolucion': fechaDevolucion.toIso8601String().split('T')[0],
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préstamo registrado correctamente')),
      );
      nombreController.clear();
      tituloController.clear();
      _fechaPrestamo = null;
      _fechaDevolucion = null;
      obtenerPrestamos(); // actualiza la lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }

  Future<void> _seleccionarFecha(BuildContext context, bool esPrestamo) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (esPrestamo) {
          _fechaPrestamo = picked;
        } else {
          _fechaDevolucion = picked;
        }
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('rol');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Usuario de BiblioGest',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'usuario@bibliogest.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Registrar nuevo préstamo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nombreController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del usuario'),
            ),
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título del libro'),
            ),
            const SizedBox(height: 10),

            /// Selector de fecha de préstamo
            Row(
              children: [
                Expanded(
                  child: Text(
                    _fechaPrestamo != null
                        ? 'Fecha de préstamo: ${_fechaPrestamo!.toLocal().toString().split(' ')[0]}'
                        : 'Fecha de préstamo: (automática)',
                  ),
                ),
                TextButton(
                  onPressed: () => _seleccionarFecha(context, true),
                  child: const Text('Seleccionar'),
                ),
              ],
            ),

            /// Selector de fecha de devolución
            Row(
              children: [
                Expanded(
                  child: Text(
                    _fechaDevolucion != null
                        ? 'Fecha de devolución: ${_fechaDevolucion!.toLocal().toString().split(' ')[0]}'
                        : 'Fecha de devolución: (opcional)',
                  ),
                ),
                TextButton(
                  onPressed: () => _seleccionarFecha(context, false),
                  child: const Text('Seleccionar'),
                ),
              ],
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                final nombre = nombreController.text.trim();
                final libro = tituloController.text.trim();
                if (nombre.isNotEmpty && libro.isNotEmpty) {
                  registrarPrestamoManual(
                    nombre,
                    libro,
                    fechaPrestamo: _fechaPrestamo,
                    fechaDevolucion: _fechaDevolucion,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos')),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Registrar préstamo'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(height: 30),
            const Text(
              'Préstamos registrados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prestamos.length,
              itemBuilder: (context, index) {
                final prestamo = prestamos[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(prestamo['libro'] ?? 'Sin título'),
                    subtitle: Text(
                      'Usuario: ${prestamo['nombre'] ?? 'N/A'}\n'
                      'Prestado: ${prestamo['fechaPrestamo'] ?? 'N/D'}\n'
                      'Devuelve: ${prestamo['fechaDevolucion'] ?? 'N/D'}',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
