import 'package:flutter/material.dart';

final themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor)
      .copyWith(surface: Colors.white),
  listTileTheme: const ListTileThemeData(
    tileColor: kPrimaryColor,
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF17192D),
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18)),
  useMaterial3: true,
);

const kPrimaryColor = Color(0xFF2188FF);
