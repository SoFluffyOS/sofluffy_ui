import 'dart:convert';

import 'package:design_system/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
    final themeJson = jsonDecode(themeData);
    _theme = AppTheme.fromJson(themeJson);
  }

  static final ThemeConfigs _instance = ThemeConfigs._();

  factory ThemeConfigs() => _instance;

  ThemeConfigs._();
}

@immutable
class AppTheme {
  final ColorData colors;
  final TypographyData typography;

  const AppTheme({
    required this.colors,
    required this.typography,
  });

  factory AppTheme.fromJson(Map<String, dynamic> json) {
    return AppTheme(
      colors: ColorData.fromJson(json['colors']),
      typography: TypographyData.fromJson(json['typography']),
    );
  }
}
