import 'dart:ui';

/// Colors as web hex text, alpha last: `#RGB`, `#RGBA`, `#RRGGBB` and
/// `#RRGGBBAA`, with or without the `#`.
abstract final class ColorHex {
  static final _digits = RegExp(r'^[0-9a-fA-F]+$');

  /// The color [text] spells, or null when it is not hex of one of those
  /// lengths.
  static Color? parse(String text) {
    final hex = text.trim().replaceFirst('#', '');
    if (!_digits.hasMatch(hex)) return null;
    final full = switch (hex.length) {
      3 || 4 => [for (final digit in hex.split('')) '$digit$digit'].join(),
      6 || 8 => hex,
      _ => null,
    };
    if (full == null) return null;
    final rgb = int.parse(full.substring(0, 6), radix: 16);
    final alpha = switch (full.length) {
      8 => int.parse(full.substring(6), radix: 16),
      _ => 0xff,
    };
    return Color(alpha << 24 | rgb);
  }

  /// `#RRGGBB`, or `#RRGGBBAA` when [withAlpha] or the color is not opaque.
  static String format(Color color, {bool withAlpha = false}) {
    String channel(double value) =>
        (value * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();
    final rgb = '#${channel(color.r)}${channel(color.g)}${channel(color.b)}';
    final isOpaque = (color.a * 255).round() == 0xff;
    if (isOpaque && !withAlpha) return rgb;
    return '$rgb${channel(color.a)}';
  }
}
