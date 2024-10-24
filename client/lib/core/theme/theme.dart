import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static border({Color color=Pallete.borderColor})=> OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color),
        );
  static final darkThemeMode = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Pallete.backgroundColor,
      appBarTheme: const AppBarTheme(backgroundColor: Pallete.backgroundColor),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(27),
        focusedBorder: border(color: Pallete.gradient2),
        enabledBorder: border()
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Pallete.backgroundColor));
}
