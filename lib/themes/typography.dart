import 'package:flutter/widgets.dart';

extension TypographyDataExtension on TypographyData {
  String? get _fontFamilyOrNull {
    final trimmed = fontFamily.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  String? get _bodyFontFamilyOrNull {
    final trimmed = bodyFontFamily?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return _fontFamilyOrNull;
    }
    return trimmed;
  }

  TextStyle get headline1 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 64.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  TextStyle get headline2 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  TextStyle get headline3 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  TextStyle get headline4 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  TextStyle get headline5 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
  );

  TextStyle get headline6 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
  );

  TextStyle get title1 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  TextStyle get title2 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  TextStyle get title3 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
  );

  TextStyle get body1 => TextStyle(
    inherit: true,
    fontFamily: _bodyFontFamilyOrNull,
    fontSize: 24.0,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
  );

  TextStyle get body2 => TextStyle(
    inherit: true,
    fontFamily: _bodyFontFamilyOrNull,
    fontSize: 17.0,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
  );

  TextStyle get base1 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  TextStyle get base2 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  TextStyle get caption1 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  TextStyle get caption2 => TextStyle(
    inherit: true,
    fontFamily: _fontFamilyOrNull,
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );
}

@immutable
class TypographyData {
  final String fontFamily;
  final String? bodyFontFamily;

  const TypographyData({
    required this.fontFamily,
    required this.bodyFontFamily,
  });

  factory TypographyData.fallback() {
    return const TypographyData(
      fontFamily: '',
      bodyFontFamily: null,
    );
  }

  factory TypographyData.fromJson(Map<String, dynamic> json) {
    return TypographyData(
      fontFamily: json['fontFamily'] as String,
      bodyFontFamily: json['bodyFontFamily'] as String?,
    );
  }

  TypographyData copyWith({
    String? fontFamily,
    String? bodyFontFamily,
  }) {
    return TypographyData(
      fontFamily: fontFamily ?? this.fontFamily,
      bodyFontFamily: bodyFontFamily ?? this.bodyFontFamily,
    );
  }

  static TypographyData lerp(TypographyData a, TypographyData b, double t) {
    // Typography doesn't lerp smoothly, so we just switch at t >= 0.5
    return t < 0.5 ? a : b;
  }
}
