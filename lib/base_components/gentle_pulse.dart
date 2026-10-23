import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// Fades [child] slowly in and out, for progress shown without movement.
class GentlePulse extends StatefulWidget {
  const GentlePulse({super.key, required this.child});

  final Widget child;

  /// One fade, out or back in.
  static const halfPeriod = Duration(milliseconds: 1400);

  /// How faint [child] gets at the bottom of a pulse.
  static const lowestOpacity = 0.35;

  @override
  State<GentlePulse> createState() => _GentlePulseState();
}

class _GentlePulseState extends State<GentlePulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: GentlePulse.halfPeriod,
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 1,
    end: GentlePulse.lowestOpacity,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
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
    if (!context.reducesMotion) return child;
    return GentlePulse(child: still);
  }
}
