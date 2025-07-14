class Libro {
  final int id;
  final String titulo;
  final String autor;
  final int anioPublicacion;
  final String isbn;
  final bool disponible;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.anioPublicacion,
    required this.isbn,
    required this.disponible,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      anioPublicacion: json['anioPublicacion'],
      isbn: json['isbn'],
      disponible: json['disponible'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'anioPublicacion': anioPublicacion,
      'isbn': isbn,
      'disponible': disponible,
    };
  }
}
