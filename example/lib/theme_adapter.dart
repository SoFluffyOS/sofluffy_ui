import 'package:flutter/material.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

extension ThemeDataExt on FluffyThemeData {
  ThemeData getTheme({
    required bool isDark,
    String? fontFamily,
  }) {
    final configuredFontFamily = fontFamily ?? typography.fontFamily;
    final effectiveFontFamily = configuredFontFamily.trim().isEmpty
        ? null
        : configuredFontFamily;
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
    final colorScheme = baseTheme.colorScheme.copyWith(
      primary: colors.primary,
      secondary: colors.secondary,
      surface: isDark ? colors.neutral7 : colors.neutral1,
      surfaceContainer: isDark ? colors.neutral5 : colors.neutral2,
      onPrimary: colors.neutral1,
      onSecondary: colors.neutral1,
      onSurface: isDark ? colors.neutral1 : colors.neutral7,
      onSurfaceVariant: isDark ? colors.neutral1 : colors.neutral7,
      surfaceTint: Colors.transparent,
      error: Colors.red,
      onError: colors.neutral1,
    );
    final dividerColor = isDark ? colors.neutral4 : colors.neutral3;
    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: effectiveFontFamily,
      ),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(
        fontFamily: effectiveFontFamily,
      ),
      primaryColor: colors.primary,
      scaffoldBackgroundColor: isDark ? colors.neutral7 : colors.neutral1,
      cardColor: isDark ? colors.neutral6 : colors.neutral2,
      canvasColor: colorScheme.surface,
      dividerColor: dividerColor,
      colorScheme: colorScheme,
    );
  }
}
