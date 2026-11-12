import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// A progress ring: spinning while progress is unknown, filled to [value]
/// otherwise. When motion is reduced, a spinning ring stands still and
/// pulses gently instead.
///
/// It moves with [LoadingClock], so a spinner costs a few frames a second
/// rather than one per vsync.
class FluffySpinner extends StatelessWidget {
  const FluffySpinner({
    super.key,
    this.value,
    this.size,
    this.strokeWidth,
    this.color,
    this.trackColor,
  });

  /// How much is done, from 0 to 1, or null while it isn't known.
  final double? value;

  /// The ring's diameter when its parent leaves it free; the parent's size
  /// otherwise. Defaults to [Spacing.d20].
  final double? size;

  /// Defaults to [Spacing.d2].
  final double? strokeWidth;

  /// Defaults to the theme's primary color.
  final Color? color;

  /// The circle behind the ring. Known progress shows a neutral one by
  /// default; a spinner shows none unless given one.
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.fluffyTheme.colors.primary;
    final strokeWidth = this.strokeWidth ?? Spacing.d2;
    final dimension = size ?? Spacing.d20;

    Widget ring(double? value, Color? track) => CustomPaint(
      size: Size.square(dimension),
      painter: ProgressRingPainter(
        clock: LoadingClock.of(context),
        value: value,
        color: color,
        trackColor: track,
        strokeWidth: strokeWidth,
      ),
    );

    if (value case final value?) {
      return ring(value, trackColor ?? neutralTrack(context));
    }

    return ReducedMotionPulse(
      still: ring(ReducedMotionPulse.stillArc, trackColor),
      child: RepaintBoundary(child: ring(null, trackColor)),
    );
  }

  /// The track behind known progress when none is given: a faint neutral
  /// that reads on light and dark backgrounds.
  static Color neutralTrack(BuildContext context) =>
      context.fluffyTheme.colors.neutral5.withValues(alpha: 0.3);
}
