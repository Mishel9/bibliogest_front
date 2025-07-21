import 'package:flutter/material.dart';
import 'package:bibliogestapp/screens/book_list_screen.dart';
import 'package:bibliogestapp/screens/favorites_screen.dart';
import 'package:bibliogestapp/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiblioGest'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 116, 200),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen superior decorativa
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'assets/images/library_banner.jpg',
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // Texto de bienvenida estilizado
            const Text(
              'Bienvenido a BiblioGest',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 76, 53, 80),
              ),
            ),

            const SizedBox(height: 10),

            // Botones de navegación estilizados
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _menuButton(
                    context,
                    label: 'Ver Libros',
                    icon: Icons.library_books,
                    color: Colors.indigo,
                    destination: const BookListScreen(),
                  ),
                  const SizedBox(height: 10),
                  _menuButton(
                    context,
                    label: 'Favoritos',
                    icon: Icons.favorite,
                    color: Colors.red,
                    destination: FavoritesScreen(),
                  ),
                  const SizedBox(height: 10),
                  _menuButton(
                    context,
                    label: 'Perfil',
                    icon: Icons.person,
                    color: Colors.blueGrey,
                    destination: const ProfileScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required Widget destination}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}
