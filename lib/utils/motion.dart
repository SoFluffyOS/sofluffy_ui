import 'package:flutter/widgets.dart';

extension MotionContext on BuildContext {
  /// Whether to replace movement with fades and still states, as the OS or
  /// the app asks through [MediaQueryData.disableAnimations].
  bool get reducesMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  /// [duration], or none when motion is reduced, for an animation that only
  /// moves, scales or resizes something.
  Duration motion(Duration duration) => switch (reducesMotion) {
    true => Duration.zero,
    false => duration,
  };
}

/// Decides whether [child] reduces motion, over what the platform reports.
class ReduceMotionScope extends StatelessWidget {
  const ReduceMotionScope({
    super.key,
    required this.reducesMotion,
    required this.child,
  });

  final bool reducesMotion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reducesMotion),
      child: child,
    );
  }
}
