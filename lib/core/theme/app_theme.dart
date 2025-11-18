import 'package:flutter/material.dart';

class AppTheme {
  static const Color madeiraEscura = Color(0xFF4E342E);
  static const Color madeiraMedia = Color(0xFF6D4C41);
  static const Color caramelo = Color(0xFFA1887F);
  static const Color begeFundo = Color(0xFFF5EDE3);
  static const Color begeSuave = Color(0xFFECE3D6);
  static const Color madeiraQueimada = Color(0xFF3E2723);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: begeFundo,
      colorScheme: const ColorScheme.light(
        primary: madeiraEscura,
        secondary: caramelo,
        surface: begeSuave,
        background: begeFundo,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: madeiraQueimada,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: madeiraEscura,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: madeiraEscura,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.35,
          color: madeiraQueimada,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          color: madeiraEscura,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: begeSuave,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(
          color: madeiraEscura,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: caramelo, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: madeiraEscura, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: madeiraEscura,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: madeiraEscura,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: begeSuave,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: caramelo, width: 1),
        ),
        shadowColor: madeiraQueimada.withOpacity(0.1),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: madeiraEscura,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: begeFundo,
        surfaceTintColor: Colors.transparent,
      ),
      iconTheme: const IconThemeData(color: madeiraEscura, size: 26),
    );
  }
}
