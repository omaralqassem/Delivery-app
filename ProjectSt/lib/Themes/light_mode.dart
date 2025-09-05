import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color(0xfff8fff8),
    onSurface: Color(0xff3f3e3e),
    primary: Color(0xfff8fff8),
    onPrimary: Color(0xffc0f158),
    primaryContainer: Color.fromARGB(207, 227, 255, 151),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xff2f2e2e)),
        foregroundColor: WidgetStatePropertyAll(Color(0xfff8fff8))),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xfff8fff8),
    foregroundColor: Color(0xff3f3e3e),
    titleTextStyle: TextStyle(fontSize: 20, color: Color(0xff3f3e3e)),
  ),
  cardTheme: const CardTheme(
    color: Color.fromARGB(207, 227, 255, 151),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xff2f2e2e),
    foregroundColor: Color(0xfff8fff8),
  ),
  textButtonTheme: TextButtonThemeData(
    style:
        ButtonStyle(foregroundColor: WidgetStatePropertyAll(Color(0xff2f2e2e))),
  ),
);
