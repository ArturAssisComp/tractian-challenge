import 'package:asset_viewer/constants.dart';
import 'package:asset_viewer/l10n/l10n.dart';
import 'package:asset_viewer/routes.dart';
import 'package:asset_viewer/service_locator.dart' as sl;
import 'package:asset_viewer/theme.dart';
import 'package:flutter/material.dart';

void main() {
  sl.setup();
  runApp(
    MaterialApp.router(
      routerConfig: generateRouter(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: kAppTitle,
      theme: themeData,
    ),
  );
}
