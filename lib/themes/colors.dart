import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/utils/extensions/strings.dart';

@immutable
class ColorData {
  final Color primary;
  final Color secondary;

  final Color neutral1;
  final Color neutral2;
  final Color neutral3;
  final Color neutral4;
  final Color neutral5;
  final Color neutral6;
  final Color neutral7;

  const ColorData({
    required this.primary,
    required this.secondary,
    required this.neutral1,
    required this.neutral2,
    required this.neutral3,
    required this.neutral4,
    required this.neutral5,
    required this.neutral6,
    required this.neutral7,
  });

  factory ColorData.fallback() {
    return const ColorData(
      primary: Color(0xFF007AFF),
      secondary: Color(0xFF5856D6),
      neutral1: Color(0xFFFFFFFF),
      neutral2: Color(0xFFF2F2F7),
      neutral3: Color(0xFFE5E5EA),
      neutral4: Color(0xFFD1D1D6),
      neutral5: Color(0xFF8E8E93),
      neutral6: Color(0xFF1C1C1E),
      neutral7: Color(0xFF000000),
    );
  }

  factory ColorData.fromJson(Map<String, dynamic> json) {
    return ColorData(
      primary: '${json['primary']}'.hexToColor(),
      secondary: '${json['secondary']}'.hexToColor(),
      neutral1: '${json['neutral1']}'.hexToColor(),
      neutral2: '${json['neutral2']}'.hexToColor(),
      neutral3: '${json['neutral3']}'.hexToColor(),
      neutral4: '${json['neutral4']}'.hexToColor(),
      neutral5: '${json['neutral5']}'.hexToColor(),
      neutral6: '${json['neutral6']}'.hexToColor(),
      neutral7: '${json['neutral7']}'.hexToColor(),
    );
  }

  ColorData copyWith({
    Color? primary,
    Color? secondary,
    Color? neutral1,
    Color? neutral2,
    Color? neutral3,
    Color? neutral4,
    Color? neutral5,
    Color? neutral6,
    Color? neutral7,
  }) {
    return ColorData(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      neutral1: neutral1 ?? this.neutral1,
      neutral2: neutral2 ?? this.neutral2,
      neutral3: neutral3 ?? this.neutral3,
      neutral4: neutral4 ?? this.neutral4,
      neutral5: neutral5 ?? this.neutral5,
      neutral6: neutral6 ?? this.neutral6,
      neutral7: neutral7 ?? this.neutral7,
    );
  }

  static ColorData lerp(ColorData a, ColorData b, double t) {
    return ColorData(
      primary: Color.lerp(a.primary, b.primary, t)!,
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      neutral1: Color.lerp(a.neutral1, b.neutral1, t)!,
      neutral2: Color.lerp(a.neutral2, b.neutral2, t)!,
      neutral3: Color.lerp(a.neutral3, b.neutral3, t)!,
      neutral4: Color.lerp(a.neutral4, b.neutral4, t)!,
      neutral5: Color.lerp(a.neutral5, b.neutral5, t)!,
      neutral6: Color.lerp(a.neutral6, b.neutral6, t)!,
      neutral7: Color.lerp(a.neutral7, b.neutral7, t)!,
    );
  }
}
