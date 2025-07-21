import '../models/libro.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;

  FavoriteService._internal();

  final List<Libro> _favoritos = [];

  List<Libro> getFavoritos() => _favoritos;

  bool esFavorito(Libro libro) {
    return _favoritos.any((l) => l.id == libro.id);
  }

  void agregarAFavoritos(Libro libro) {
    if (!esFavorito(libro)) {
      _favoritos.add(libro);
    }
  }

  void eliminarDeFavoritos(Libro libro) {
    _favoritos.removeWhere((l) => l.id == libro.id);
  }
}
