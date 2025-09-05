import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _selectedLocale = Locale('en'); // Default locale is English

  Locale get selectedLocale => _selectedLocale;

  void setLocale(Locale locale) {
    _selectedLocale = locale;
    notifyListeners();
  }
}
