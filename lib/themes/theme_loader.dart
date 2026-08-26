import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sofluffy_ui/constants/strings.dart';
import 'package:sofluffy_ui/themes/app_theme.dart';

/// Utility class for loading theme configurations from JSON assets.
class ThemeLoader {
  const ThemeLoader._();

  /// Load a theme from the assets by name.
  ///
  /// The theme file should be located at `assets/themes/$themeName.json`.
  static Future<FluffyThemeData> load(String themeName) async {
    final themeData = await rootBundle.loadString(
      'assets/themes/$themeName.json',
      cache: false,
    );
    final themeJson = jsonDecode(themeData) as Map<String, dynamic>;
    return FluffyThemeData.fromJson(themeJson);
  }

  /// Load the default theme.
  static Future<FluffyThemeData> loadDefault() => load(kDefaultThemeName);
}
