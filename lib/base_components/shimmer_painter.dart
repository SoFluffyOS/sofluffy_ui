import 'package:flutter/widgets.dart';

/// Paints [FluffyShimmer]: a box in [baseColor] with rounded corners, and a
/// band of [highlightColor] sweeping across it with [clock].
///
/// The box takes the gradient straight, so no layer is saved and composited
/// on every step as a mask over a child would be.
class ShimmerPainter extends CustomPainter {
  ShimmerPainter({
    required this.clock,
    required this.baseColor,
    required this.highlightColor,
    required this.borderRadius,
  }) : super(repaint: clock);

  final Animation<double> clock;
  final Color baseColor;
  final Color highlightColor;
  final double borderRadius;

  /// Seconds for one sweep across the box.
  static const sweepSeconds = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = (clock.value / sweepSeconds) % 1;
    final band = Rect.fromLTWH(
      size.width * (progress * 2 - 1),
      0,
      size.width,
      size.height,
    );
    final gradient = LinearGradient(
      colors: [baseColor, highlightColor, baseColor],
      stops: const [0.35, 0.5, 0.65],
    ).createShader(band);

    final box = RSuperellipse.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );
    canvas.drawRSuperellipse(box, Paint()..shader = gradient);
  }

  @override
  bool shouldRepaint(ShimmerPainter oldDelegate) =>
      oldDelegate.clock != clock ||
      oldDelegate.baseColor != baseColor ||
      oldDelegate.highlightColor != highlightColor ||
      oldDelegate.borderRadius != borderRadius;
}
