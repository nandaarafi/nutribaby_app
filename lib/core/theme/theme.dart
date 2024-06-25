import 'package:flutter/material.dart';
import 'package:nutribaby_app/core/theme/text_theme.dart';

class NTheme {
  NTheme._();

  static ThemeData lightTheme = ThemeData(
    dialogTheme: DialogTheme(backgroundColor: Colors.white),
    canvasColor: Colors.white,
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.yellow,
    scaffoldBackgroundColor: Colors.white,
    textTheme: NTextTheme.lightTextTheme,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple,
      // primary: Colors.blue
    ),

  );
}