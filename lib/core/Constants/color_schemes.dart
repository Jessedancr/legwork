import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(),
);

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xffFFC107), // Golden yellow
    secondary: Color(0xffD4AF37), // Antique gold
    surface: Color(0xff8B4513), // Warm brown
  ),
);

ThemeData seedSchemeLight = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
  ),
);


ThemeData seedSchemeDark = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
);