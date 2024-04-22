import 'package:flutter/material.dart';


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  ),
);