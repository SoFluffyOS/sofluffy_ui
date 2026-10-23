import 'package:flutter/material.dart'
    show CircularProgressIndicator, LinearProgressIndicator;
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// A progress ring: spinning while progress is unknown, filled to [value]
/// otherwise. When motion is reduced, a spinning ring stands still and
/// pulses gently instead.
class FluffySpinner extends StatelessWidget {
  const FluffySpinner({super.key, this.value, this.strokeWidth, this.color})
    : adaptive = false;

  /// The platform's own indicator: Cupertino's on Apple platforms.
  const FluffySpinner.adaptive({super.key, this.value})
    : adaptive = true,
      strokeWidth = null,
      color = null;

  final double? value;
  final double? strokeWidth;
  final Color? color;
  final bool adaptive;

  Widget _ring(double? value) => switch (adaptive) {
    true => CircularProgressIndicator.adaptive(value: value),
    false => CircularProgressIndicator(
      value: value,
      strokeWidth: strokeWidth,
      color: color,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final spins = value == null;
    if (!spins) return _ring(value);
    return ReducedMotionPulse(
      // A full Cupertino wheel reads as one at rest.
      still: _ring(switch (adaptive) {
        true => 1,
        false => ReducedMotionPulse.stillArc,
      }),
      child: _ring(null),
    );
  }
}

/// A progress bar: sweeping while progress is unknown, filled to [value]
/// otherwise. When motion is reduced, a sweeping bar fills and pulses
/// gently instead.
class FluffyProgressBar extends StatelessWidget {
  const FluffyProgressBar({
    super.key,
    this.value,
    this.minHeight,
    this.color,
    this.backgroundColor,
  });

  final double? value;
  final double? minHeight;
  final Color? color;
  final Color? backgroundColor;

  Widget _bar(double? value) => LinearProgressIndicator(
    value: value,
    minHeight: minHeight,
    color: color,
    backgroundColor: backgroundColor,
  );

  @override
  Widget build(BuildContext context) {
    final sweeps = value == null;
    if (!sweeps) return _bar(value);
    return ReducedMotionPulse(still: _bar(1), child: _bar(null));
  }
}
