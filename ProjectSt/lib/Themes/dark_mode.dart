import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color(0xff3f3e3e),
    onSurface: Color(0xffffffff),
    primary: Color(0xff2f2e2e),
    onPrimary: Color(0xffc0f158),
    primaryContainer: Color.fromARGB(207, 227, 255, 151),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xffffffff)),
        foregroundColor: WidgetStatePropertyAll(Color(0xff2f2e2e))),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff3f3e3e),
    foregroundColor: Color(0xfff8fff8),
    titleTextStyle: TextStyle(fontSize: 20, color: Color(0xffffffff)),
  ),
  cardTheme: const CardTheme(
    color: Color(0xff2f2e2e),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xfff8fff8),
    foregroundColor: Color(0xff2f2e2e),
  ),
  textButtonTheme: TextButtonThemeData(
    style:
        ButtonStyle(foregroundColor: WidgetStatePropertyAll(Color(0xffffffff))),
  ),
);
