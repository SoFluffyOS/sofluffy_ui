import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// A shimmer sweeping across [child]'s shape while content loads, or the
/// shape in [baseColor] pulsing gently when motion is reduced.
class FluffyShimmer extends StatelessWidget {
  const FluffyShimmer({
    super.key,
    required this.baseColor,
    required this.highlightColor,
    required this.child,
  });

  final Color baseColor;
  final Color highlightColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!context.reducesMotion) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child,
      );
    }
    return GentlePulse(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(baseColor, BlendMode.srcIn),
        child: child,
      ),
    );
  }
}
