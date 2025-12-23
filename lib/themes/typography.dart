import 'package:flutter/material.dart';

extension TypographyDataExtension on TypographyData {
  TextStyle get headline1 => const TextStyle(
    fontSize: 64.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headline2 => const TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headline3 => const TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headline4 => const TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get headline5 => const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
  );

  TextStyle get headline6 => const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );

  TextStyle get body1 => const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.normal,
  );

  TextStyle get body2 => const TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.normal,
  );

  TextStyle get base1 => const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get base2 => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get caption1 => const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get caption2 => const TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
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
