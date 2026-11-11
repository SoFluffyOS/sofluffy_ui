import 'package:flutter/material.dart' show ProgressIndicatorTheme;
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// A progress bar: sweeping while progress is unknown, filled to [value]
/// otherwise. When motion is reduced, a sweeping bar fills and pulses
/// gently instead.
///
/// It moves with [LoadingClock], so a bar costs a few frames a second
/// rather than one per vsync.
class FluffyProgressBar extends StatelessWidget {
  const FluffyProgressBar({
    super.key,
    this.value,
    this.minHeight,
    this.color,
    this.backgroundColor,
  });

  /// How much is done, from 0 to 1, or null while it isn't known.
  final double? value;

  /// Defaults to [Spacing.d4].
  final double? minHeight;

  /// Defaults to the theme's primary color.
  final Color? color;

  /// The track. Defaults to the theme's, else a faint neutral.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = ProgressIndicatorTheme.of(context);
    final color = this.color ?? context.fluffyTheme.colors.primary;
    final trackColor =
        backgroundColor ??
        theme.linearTrackColor ??
        FluffySpinner.neutralTrack(context);
    final borderRadius = switch (theme.borderRadius) {
      final BorderRadius radius => radius,
      _ => BorderRadius.zero,
    };

    Widget bar(double? value) => ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: minHeight ?? Spacing.d4,
      ),
      child: CustomPaint(
        painter: ProgressBarPainter(
          clock: LoadingClock.of(context),
          value: value,
          color: color,
          trackColor: trackColor,
          borderRadius: borderRadius,
        ),
      ),
    );

    if (value case final value?) {
      return bar(value);
    }

    return ReducedMotionPulse(
      still: bar(1),
      child: RepaintBoundary(child: bar(null)),
    );
  }
}
