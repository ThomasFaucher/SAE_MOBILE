import 'package:flutter/material.dart';

final theme = ThemeData(
  primarySwatch: Colors.orange,
  accentColor: Colors.deepOrangeAccent,
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    bodyText1: TextStyle(fontSize: 16.0),
    bodyText2: TextStyle(fontSize: 14.0),
    button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.orange,
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.orange, width: 1.5),
    ),
  ),
);
