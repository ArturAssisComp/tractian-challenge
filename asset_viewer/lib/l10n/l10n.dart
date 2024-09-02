import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extension for AppLocalization in order to make it easier using l10n
/// features.
extension AppLocalizationsExt on BuildContext {
  /// Getter that makes it easier for using the l10n localization functionality.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
