import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

extension ThemeDataExt on AppTheme {
  ThemeData getTheme({
    required bool isDark,
  }) {
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
    return baseTheme.copyWith(
      primaryColor: colors.primary,
      scaffoldBackgroundColor: isDark ? colors.neutral6 : colors.neutral2,
      cardColor: isDark ? colors.neutral7 : colors.neutral1,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: colors.primary,
        surface: isDark ? colors.neutral7 : colors.neutral1,
        surfaceTint: Colors.transparent,
        error: Colors.red,
      ),
    );
  }
}
