import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF2C4A87),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C4A87),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2C4A87),
          secondary: const Color(0xFFF97316),
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFF3A3A3A),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFF97316),
        ),
      );
}