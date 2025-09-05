import 'package:flutter/material.dart';
import '../Themes/dark_mode.dart';
import '../Themes/light_mode.dart';

class LeProvider extends ChangeNotifier {
  // default is light mode
  ThemeData _themeData = darkMode;

  // get theme
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    // update UI
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  // default is light mode
  Locale _locale = Locale('en');

  // get theme
  Locale get locale => _locale;

  // is dark mode
  bool get isEnLocale => _locale == Locale('en');

  // set theme
  set locale(Locale locale) {
    _locale = locale;
    // update UI
    notifyListeners();
  }

  // toggle theme
  void toggleLocale() {
    if (_locale == Locale('ar')) {
      _locale = Locale('en');
    } else {
      _locale = Locale('ar');
    }
    notifyListeners();
  }
}
