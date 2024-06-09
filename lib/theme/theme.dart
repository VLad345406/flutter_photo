import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.blue,
    cursorColor: Colors.black,
    selectionHandleColor: Colors.black,
  ),
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.black,
    secondary: Colors.white,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.blue,
    cursorColor: Colors.white,
    selectionHandleColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.white,
    secondary: Colors.black,
  ),
);