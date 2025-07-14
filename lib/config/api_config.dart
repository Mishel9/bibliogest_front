import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api'; // 🔁 CORRECTO para emulador Android
    } else if (Platform.isIOS) {
      return 'http://localhost:8080/api'; // Simulador iOS puede usar localhost
    } else {
      return 'http://localhost:8080/api';
    }
  }

  static String get loginEndpoint => '$baseUrl/auth/login';
  static String get registerEndpoint => '$baseUrl/auth/register';
  static String get librosEndpoint => '$baseUrl/libros';
  static String get favoritosEndpoint => '$baseUrl/favoritos';
}
