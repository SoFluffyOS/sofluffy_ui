import 'dart:convert';

import 'package:design_system/constants/strings.dart';
import 'package:design_system/themes/app_theme.dart';
import 'package:flutter/services.dart';

/// Utility class for loading theme configurations from JSON assets.
class ThemeLoader {
  const ThemeLoader._();

  /// Load a theme from the assets by name.
  ///
  /// The theme file should be located at `assets/themes/$themeName.json`.
  static Future<AppTheme> load(String themeName) async {
    final themeData = await rootBundle.loadString(
      'assets/themes/$themeName.json',
      cache: false,
    );
    final themeJson = jsonDecode(themeData) as Map<String, dynamic>;
    return AppTheme.fromJson(themeJson);
  }

  /// Load the default theme.
  static Future<AppTheme> loadDefault() => load(kDefaultThemeName);
}
