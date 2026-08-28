import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/themes/colors.dart';
import 'package:sofluffy_ui/themes/typography.dart';

/// Theme configuration data containing colors, typography, and brightness.
///
/// Access via `FluffyTheme.of(context)` or the convenience extension `context.fluffyTheme`.
@immutable
class FluffyThemeData {
  final ColorData colors;
  final TypographyData typography;
  final Brightness brightness;
  final TargetPlatform? platform;

  const FluffyThemeData({
    required this.colors,
    required this.typography,
    this.brightness = Brightness.light,
    this.platform,
  });

  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;

  factory FluffyThemeData.fallback({Brightness brightness = Brightness.light}) {
    return FluffyThemeData(
      colors: ColorData.fallback(),
      typography: TypographyData.fallback(),
      brightness: brightness,
    );
  }

  factory FluffyThemeData.fromJson(
    Map<String, dynamic> json, {
    Brightness brightness = Brightness.light,
  }) {
    return FluffyThemeData(
      colors: ColorData.fromJson(json['colors'] as Map<String, dynamic>),
      typography: TypographyData.fromJson(
        json['typography'] as Map<String, dynamic>,
      ),
      brightness: brightness,
    );
  }

  FluffyThemeData copyWith({
    ColorData? colors,
    TypographyData? typography,
    Brightness? brightness,
    TargetPlatform? platform,
  }) {
    return FluffyThemeData(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      brightness: brightness ?? this.brightness,
      platform: platform ?? this.platform,
    );
  }

  static FluffyThemeData lerp(
    FluffyThemeData a,
    FluffyThemeData b,
    double t,
  ) {
    return FluffyThemeData(
      colors: ColorData.lerp(a.colors, b.colors, t),
      typography: TypographyData.lerp(a.typography, b.typography, t),
      brightness: switch (t < 0.5) {
        true => a.brightness,
        false => b.brightness,
      },
      platform: switch (t < 0.5) {
        true => a.platform,
        false => b.platform,
      },
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FluffyThemeData &&
        other.colors == colors &&
        other.typography == typography &&
        other.brightness == brightness &&
        other.platform == platform;
  }

  @override
  int get hashCode => Object.hash(colors, typography, brightness, platform);
}
