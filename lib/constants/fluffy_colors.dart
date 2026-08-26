import 'package:flutter/widgets.dart';

/// Common static colors used across Fluffy UI.
///
/// Named [FluffyColors] (plural) to avoid conflict with Flutter Material's `Colors` class.
class FluffyColors {
  const FluffyColors._();

  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color barrier = Color(0x80000000);
  static const Color shadow = Color(0x33000000);
  static const Color shadowLight = Color(0x1A000000); // alpha: 0.1
  static const Color shadowMedium = Color(0x26000000); // alpha: 0.15

  // Status & semantic colors
  static const Color error = Color(0xFFF44336);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningAlt = Color(0xFFFFB300);
  static const Color info = Color(0xFF2196F3);
  static const Color grey = Color(0xFF9E9E9E);

  // Shimmer colors
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFEEEEEE);
  static const Color shimmerHighlightLightAlt = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF616161);
  static const Color shimmerHighlightDark = Color(0xFF757575);
}
