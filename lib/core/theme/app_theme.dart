import 'package:flutter/material.dart';

class AppTheme {
  // MacroFactor exact colors
  static const Color black = Color(0xFF000000); // Pure black background
  static const Color teal = Color(0xFF00D9C0); // MacroFactor teal accent
  static const Color cardDark = Color(0xFF1A1A1A); // Slightly lighter for cards
  static const Color textGray = Color(0xFF888888); // Secondary text
  
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    primaryColor: teal,
    colorScheme: const ColorScheme.dark(
      primary: teal,
      secondary: teal,
      surface: cardDark,
      onSurface: Colors.white,
    ),
    cardTheme: const CardThemeData(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: textGray),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardDark,
      selectedItemColor: teal,
      unselectedItemColor: textGray,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
