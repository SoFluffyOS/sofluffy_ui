import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

extension ThemeDataExt on AppTheme {
  ThemeData getTheme({required bool isDark}) {
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
    return baseTheme.copyWith(
      primaryColor: colors.primary,
      primaryColorDark: colors.primary,
      primaryColorLight: colors.primary,
      secondaryHeaderColor: colors.secondary,
      scaffoldBackgroundColor: isDark ? colors.neutral6 : colors.neutral2,
      cardColor: isDark ? colors.neutral7 : colors.neutral1,
      dividerColor: isDark ? colors.neutral4 : colors.neutral3,
      dividerTheme: DividerThemeData(
        color: isDark ? colors.neutral4 : colors.neutral3,
      ),
      disabledColor: isDark ? colors.neutral5 : colors.neutral4,
      hintColor: isDark ? colors.neutral4 : colors.neutral5,
      dialogTheme: DialogThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: isDark ? colors.neutral7 : colors.neutral1,
      ),
      tabBarTheme: TabBarThemeData(indicatorColor: colors.secondary),
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? colors.neutral7 : colors.neutral1,
        foregroundColor: isDark ? colors.neutral1 : colors.neutral7,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? colors.neutral7 : colors.neutral1,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? colors.neutral7 : colors.neutral1,
        selectedItemColor: colors.primary,
        unselectedItemColor: isDark ? colors.neutral4 : colors.neutral5,
      ),
      iconTheme: IconThemeData(
        color: isDark ? colors.neutral1 : colors.neutral7,
        opacity: isDark ? 0.8 : 1.0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: isDark ? colors.neutral1 : colors.neutral7,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: isDark ? colors.neutral1 : colors.neutral7,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return isDark ? colors.neutral5 : colors.neutral3;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary.withValues(alpha: 0.5);
          }
          return isDark ? colors.neutral4 : colors.neutral4;
        }),
      ),
    );
  }
}
