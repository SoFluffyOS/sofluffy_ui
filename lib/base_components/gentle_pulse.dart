import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// Fades [child] slowly in and out, for progress shown without movement.
///
/// It fades with [LoadingClock], so every pulse on screen keeps time.
class GentlePulse extends StatelessWidget {
  const GentlePulse({super.key, required this.child});

  final Widget child;

  /// One fade, out or back in.
  static const halfPeriod = Duration(milliseconds: 1400);

  /// How faint [child] gets at the bottom of a pulse.
  static const lowestOpacity = 0.35;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: LoadingClock.of(context).drive(const _PulseOpacity()),
      child: child,
    );
  }
}

/// Seconds on [LoadingClock] to opacity: from 1 down to
/// [GentlePulse.lowestOpacity] and back, easing each way.
class _PulseOpacity extends Animatable<double> {
  const _PulseOpacity();

  static final _halfPeriodSeconds =
      GentlePulse.halfPeriod.inMicroseconds / Duration.microsecondsPerSecond;

  @override
  double transform(double seconds) {
    final phase = (seconds / _halfPeriodSeconds) % 2;
    final fading = switch (phase <= 1) {
      true => phase,
      false => 2 - phase,
    };
    final eased = Curves.easeInOut.transform(fading);

    return 1 - (1 - GentlePulse.lowestOpacity) * eased;
  }
}

/// [child], a moving progress indicator, or [still] pulsing gently in its
/// place when motion is reduced.
class ReducedMotionPulse extends StatelessWidget {
  const ReducedMotionPulse({
    super.key,
    required this.still,
    required this.child,
  });

  final Widget still;
  final Widget child;

  /// How much of a spinner's ring shows in its [still] version.
  static const stillArc = 0.75;

  @override
  Widget build(BuildContext context) {
    if (!context.reducesMotion) {
      return child;
    }

    return GentlePulse(child: still);
  }
}
