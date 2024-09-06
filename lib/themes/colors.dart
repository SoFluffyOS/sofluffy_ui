import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

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
}
