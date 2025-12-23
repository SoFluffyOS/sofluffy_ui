import 'dart:convert';

import 'package:design_system/constants/strings.dart';
import 'package:design_system/themes/app_theme.dart';
import 'package:flutter/services.dart';

/// **Deprecated**: Use [ThemeLoader] to load themes and [AppThemeData] to
/// provide themes to the widget tree.
///
/// This singleton is kept for backward compatibility but should be migrated
/// to the new context-based system.
@Deprecated('Use ThemeLoader and AppThemeData instead')
class ThemeConfigs {
  AppTheme? _theme;

  AppTheme get theme {
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
    _theme = AppTheme.fromJson(themeJson);
  }

  static final ThemeConfigs _instance = ThemeConfigs._();

  factory ThemeConfigs() => _instance;

  ThemeConfigs._();
}
