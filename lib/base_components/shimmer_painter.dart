import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// Paints [FluffyShimmer]: a box in [baseColor] with rounded corners, and a
/// slanted band of [highlightColor] sweeping across it with [clock].
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
    if (size.isEmpty) {
      return;
    }

    final band = ShimmerBand(size, (clock.value / sweepSeconds) % 1);
    final (begin, end) = band.ends;
    final box = Offset.zero & size;
    final gradient = LinearGradient(
      begin: begin,
      end: end,
      colors: [baseColor, highlightColor, baseColor],
      transform: _Slide(band.slide),
    ).createShader(box);

    canvas.drawRSuperellipse(
      RSuperellipse.fromRectAndRadius(box, Radius.circular(borderRadius)),
      Paint()..shader = gradient,
    );
  }

  @override
  bool shouldRepaint(ShimmerPainter oldDelegate) =>
      oldDelegate.clock != clock ||
      oldDelegate.baseColor != baseColor ||
      oldDelegate.highlightColor != highlightColor ||
      oldDelegate.borderRadius != borderRadius;
}

class _Slide extends GradientTransform {
  const _Slide(this.offset);

  final Offset offset;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(offset.dx, offset.dy, 0);
}
