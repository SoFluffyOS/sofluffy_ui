import 'package:design_system/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] for convenient theme access.
extension ThemeConfigsExtension on BuildContext {
  /// Access the [AppTheme] from ThemeData extensions.
  ///
  /// Throws if no [AppTheme] is found in the theme extensions.
  AppTheme get themeConfigs {
    final theme = Theme.of(this).extension<AppTheme>();
    if (theme == null) {
      throw FlutterError(
        'themeConfigs called with a context that does not contain an AppTheme extension.\n'
        'Make sure to use appTheme.getTheme() which includes the AppTheme extension.',
      );
    }
    return theme;
  }

  /// Access the [AppTheme] from ThemeData extensions, or null if not found.
  AppTheme? get maybeThemeConfigs => Theme.of(this).extension<AppTheme>();

  /// Alias for [themeConfigs].
  AppTheme get appTheme => themeConfigs;
}
