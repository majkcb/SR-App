import 'package:flutter/material.dart';

ThemeData getAppTheme() {
  return ThemeData(
    primarySwatch: Colors.amber,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ), bottomAppBarTheme: const BottomAppBarTheme(color: Colors.grey),
  );
}
