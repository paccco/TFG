import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class Colores {
  static const Color blanco = Color(0xFFFFFFFF); // Blanco
  static const Color negro = Color(0xFF000000); // Negro
  static const Color naranja = Color(0xFFFF9500); // Naranja
  static const Color azul = Color(0xFF007AFF); // Azul
  static const Color azulOscuro = Color(0xFF0A2540); // Azul oscuro
  static const Color grisClaro = Color(0xFFF2F2F7); // Gris claro
  static const Color grisMuyOscuro = Color(0xFF121212); // Gris oscuro
  static const Color rojo = Color(0xFFC61111); // Rojo
  static const Color grisOscuro = Color(0xFF1E1E1E); // Gris muy oscuro
  static const Color verde = Color(0xFF34C759); // Verde
  static const Color morado = Color(0xFFAF52DE); // Morado
  static const Color gris = Color(0xFFD9D9D9); // Gris
}

class Tamanios{
  static double get appBarH => 8.5.h;
  static double get appBarExitW => 15.5.w;
  static double get appBarTextW => 75.w;
  static double get botonAniadir => 8.h;
  static double get fuenteAniadir => 22.sp;
  static double get fuenteTitulo => 30.sp;
  static double get fuentePopUp => 16.sp;
}
