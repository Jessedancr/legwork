import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (_themeData.brightness == Brightness.dark) {
      _themeData = ThemeData.light();
      prefs.setBool('isDarkMode', false);
    } else {
      _themeData = ThemeData.dark();
      prefs.setBool('isDarkMode', true);
    }
    notifyListeners();
  }

// * Load theme preferences from shared prefs
  Future<void> loadThemePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
