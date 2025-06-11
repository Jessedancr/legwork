import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // * initially set it to light mode
  ThemeData _themeData = ThemeData.light();

  // * get the current theme data
  ThemeData get themeData => _themeData;

  // * Check if it is dark mode
  bool get isDarkMode => _themeData.brightness == Brightness.dark;

  // * Set the theme data
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // * Toogle method to switch btw the two
  void toggleTheme() {
    if (_themeData.brightness == Brightness.dark) {
      _themeData = ThemeData.light();
    } else {
      _themeData = ThemeData.dark();
    }
    notifyListeners();
  }
}
