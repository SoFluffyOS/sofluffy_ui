import 'package:flutter/material.dart';

extension ColorExtension on String {
  Color hexToColor() {
    return toColor() ?? Colors.transparent;
  }

  Color? toColor() {
    var hexColor = replaceAll('#', '');
    if (hexColor.length != 6 && hexColor.length != 8) {
      return null;
    }

    if (hexColor.length == 8) {
      /// The hexColor from web has the format RRGGBBAA.
      /// Need to change to Flutter's format: AARRGGBB.
      final alpha = hexColor.substring(6, 8);
      final color = hexColor.substring(0, 6);
      hexColor = '$alpha$color';
    }

    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length != 8) {
      return null;
    }

    return Color(int.parse('0x$hexColor'));
  }
}
