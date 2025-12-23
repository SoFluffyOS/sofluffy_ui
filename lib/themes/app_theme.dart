import 'package:design_system/themes/colors.dart';
import 'package:design_system/themes/typography.dart';
import 'package:flutter/material.dart';

/// Custom theme extension that contains app-specific theming data.
///
/// Access via `Theme.of(context).extension<AppTheme>()` or use the
/// convenience extension `context.appTheme`.
@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  final ColorData colors;
  final TypographyData typography;

  const AppTheme({
    required this.colors,
    required this.typography,
  });

  factory AppTheme.fromJson(Map<String, dynamic> json) {
    return AppTheme(
      colors: ColorData.fromJson(json['colors'] as Map<String, dynamic>),
      typography: TypographyData.fromJson(
        json['typography'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  AppTheme copyWith({
    ColorData? colors,
    TypographyData? typography,
  }) {
    return AppTheme(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
    );
  }

  @override
  AppTheme lerp(covariant AppTheme? other, double t) {
    if (other == null) return this;
    return AppTheme(
      colors: ColorData.lerp(colors, other.colors, t),
      typography: TypographyData.lerp(typography, other.typography, t),
    );
  }
}
