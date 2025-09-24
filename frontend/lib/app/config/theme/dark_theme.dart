import 'package:flutter/material.dart';

final ThemeData darkThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade800, width: 0.5),
    ),
  ),
);
