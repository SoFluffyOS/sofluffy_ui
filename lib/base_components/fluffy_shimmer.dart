import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// A placeholder box in [baseColor] with a shimmer sweeping across it while
/// content loads, or pulsing gently when motion is reduced.
///
/// It fills its parent, as an empty [Container] does, and moves with
/// [LoadingClock].
class FluffyShimmer extends StatelessWidget {
  const FluffyShimmer({
    super.key,
    required this.baseColor,
    required this.highlightColor,
    this.borderRadius,
  });

  final Color baseColor;
  final Color highlightColor;

  /// The corners' radius, as a superellipse. Square by default.
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 0;

    final Widget box = switch (context.reducesMotion) {
      false => RepaintBoundary(
        child: CustomPaint(
          painter: ShimmerPainter(
            clock: LoadingClock.of(context),
            baseColor: baseColor,
            highlightColor: highlightColor,
            borderRadius: radius,
          ),
        ),
      ),
      true => GentlePulse(
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: baseColor,
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          ),
        ),
      ),
    };

    return LimitedBox(
      maxWidth: 0,
      maxHeight: 0,
      child: SizedBox.expand(child: box),
    );
  }
}
