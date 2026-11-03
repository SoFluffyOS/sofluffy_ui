import 'package:flutter/widgets.dart';

/// The color picker's own, not exported: apps often have one by that name.
///
/// The light and dark squares behind a color with alpha, so its
/// transparency shows.
class CheckerboardPainter extends CustomPainter {
  const CheckerboardPainter({required this.square});

  /// A square's side, in logical pixels.
  final double square;

  static const _light = Color(0xffffffff);
  static const _dark = Color(0xffcccccc);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _light);
    final dark = Paint()..color = _dark;
    for (var y = 0; y * square < size.height; y++) {
      for (var x = y.isOdd ? 1 : 0; x * square < size.width; x += 2) {
        canvas.drawRect(
          Rect.fromLTWH(x * square, y * square, square, square),
          dark,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CheckerboardPainter oldDelegate) =>
      oldDelegate.square != square;
}
