class Libro {
  int? id;
  String titulo;
  String autor;
  int anioPublicacion;
  String isbn;
  bool disponible;

  Libro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.anioPublicacion,
    required this.isbn,
    required this.disponible,
  });

  factory Libro.fromJson(Map<String, dynamic> json) => Libro(
        id: json['id'],
        titulo: json['titulo'],
        autor: json['autor'],
        anioPublicacion: json['anioPublicacion'],
        isbn: json['isbn'],
        disponible: json['disponible'],
      );

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'autor': autor,
        'anioPublicacion': anioPublicacion,
        'isbn': isbn,
        'disponible': disponible,
      };
}
