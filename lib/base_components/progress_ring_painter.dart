import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Paints [FluffySpinner]'s ring: [value] of it from the top, or a
/// three-quarter arc turning once a second with [clock] while [value] is
/// null; round caps, over [trackColor] when there is one.
class ProgressRingPainter extends CustomPainter {
  ProgressRingPainter({
    required this.clock,
    required this.value,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  }) : super(
         repaint: switch (value) {
           null => clock,
           _ => null,
         },
       );

  final Animation<double> clock;
  final double? value;
  final Color color;
  final Color? trackColor;
  final double strokeWidth;

  /// How much of the ring a spinning arc covers.
  static const spinningArc = 0.75;

  static const _top = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    if (radius <= 0) {
      return;
    }

    final rect = Rect.fromCircle(center: center, radius: radius);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (trackColor case final track?) {
      canvas.drawCircle(center, radius, stroke..color = track);
    }

    final (start, share) = switch (value) {
      final value? => (_top, value.clamp(0.0, 1.0)),
      null => (_top + clock.value * 2 * math.pi, spinningArc),
    };
    if (share <= 0) {
      return;
    }

    canvas.drawArc(
      rect,
      start,
      share * 2 * math.pi,
      false,
      stroke..color = color,
    );
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) =>
      oldDelegate.clock != clock ||
      oldDelegate.value != value ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}
