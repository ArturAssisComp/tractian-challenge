import 'package:flutter/material.dart';

final themeData = ThemeData(
  listTileTheme: ListTileThemeData(
    tileColor: Color(0xFF2188FF),
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF17192D),
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18)),
  useMaterial3: true,
);
