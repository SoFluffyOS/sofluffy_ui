import 'package:flutter/widgets.dart';

/// Paints [FluffyProgressBar]: [color] filled to [value] over
/// [trackColor], or a third of the bar sweeping across with [clock] while
/// [value] is null.
class ProgressBarPainter extends CustomPainter {
  ProgressBarPainter({
    required this.clock,
    required this.value,
    required this.color,
    required this.trackColor,
    required this.borderRadius,
  }) : super(
         repaint: switch (value) {
           null => clock,
           _ => null,
         },
       );

  final Animation<double> clock;
  final double? value;
  final Color color;
  final Color trackColor;
  final BorderRadius borderRadius;

  /// Seconds for one sweep across the bar.
  static const sweepSeconds = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final bar = borderRadius.toRRect(Offset.zero & size);
    canvas.drawRRect(bar, Paint()..color = trackColor);

    final fill = switch (value) {
      final value? => Rect.fromLTWH(
        0,
        0,
        size.width * value.clamp(0.0, 1.0),
        size.height,
      ),
      null => _sweep(size),
    };
    canvas
      ..save()
      ..clipRRect(bar)
      ..drawRect(fill, Paint()..color = color)
      ..restore();
  }

  Rect _sweep(Size size) {
    final width = size.width / 3;
    final progress = Curves.easeInOut.transform(
      (clock.value / sweepSeconds) % 1,
    );
    final left = (size.width + width) * progress - width;

    return Rect.fromLTWH(left, 0, width, size.height);
  }

  @override
  bool shouldRepaint(ProgressBarPainter oldDelegate) =>
      oldDelegate.clock != clock ||
      oldDelegate.value != value ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.borderRadius != borderRadius;
}
