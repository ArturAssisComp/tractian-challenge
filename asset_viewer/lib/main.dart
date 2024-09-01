import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/routes.dart';
import 'package:asset_viewer/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp.router(
      routerConfig: generateRouter(),
      title: kAppTitle,
      theme: themeData,
    ),
  );
}
