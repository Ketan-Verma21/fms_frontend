import 'package:flutter/material.dart';

ThemeData buildPurpleTheme() {
  const primaryPurple = Color(0xFF6C63FF);
  const deepPurple = Color(0xFF4B3CFA);
  const lightPurple = Color(0xFFD8D3FF);

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryPurple,
    onPrimary: Colors.white,
    secondary: deepPurple,
    onSecondary: Colors.white,
    error: const Color(0xFFB00020),
    onError: Colors.white,
    background: lightPurple,
    onBackground: Colors.black87,
    surface: Colors.white,
    onSurface: Colors.black87,
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: lightPurple,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryPurple,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryPurple),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: deepPurple, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorColor: Colors.white,
    ),
  );
}

