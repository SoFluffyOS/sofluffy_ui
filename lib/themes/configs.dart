import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sofluffy_ui/constants/strings.dart';
import 'package:sofluffy_ui/themes/app_theme.dart';

/// **Deprecated**: Use [ThemeLoader] to load themes and [AppThemeData] to
/// provide themes to the widget tree.
///
/// This singleton is kept for backward compatibility but should be migrated
/// to the new context-based system.
@Deprecated('Use ThemeLoader and FluffyTheme instead')
class ThemeConfigs {
  FluffyThemeData? _theme;

  FluffyThemeData get theme {
    if (_theme == null) {
      throw Exception('Theme not loaded');
    }
    return _theme!;
  }

  Future<void> init() async {
    await load(kDefaultThemeName);
  }

  Future<void> load(String themeName) async {
    final themeData = await rootBundle.loadString(
      'assets/themes/$themeName.json',
      cache: false,
    );
    final themeJson = jsonDecode(themeData) as Map<String, dynamic>;
    _theme = FluffyThemeData.fromJson(themeJson);
  }

  static final ThemeConfigs _instance = ThemeConfigs._();

  factory ThemeConfigs() => _instance;

  ThemeConfigs._();
}
