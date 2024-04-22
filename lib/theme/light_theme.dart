import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey[300]!,
    primary: Colors.grey[200]!,
    secondary: Colors.grey[400]!,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Цвет основного текста
 ),
);
