import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class LoadingBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double? size;
  final double? shimmerBorderRadius;

  const LoadingBox({
    super.key,
    this.width,
    this.height,
    this.size,
    this.shimmerBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return SizedBox(
      width: size ?? width,
      height: size ?? height,
      child: Shimmer.fromColors(
        baseColor: isDark
            ? FluffyColors.shimmerBaseDark
            : FluffyColors.shimmerBaseLight,
        highlightColor: isDark
            ? FluffyColors.shimmerHighlightDark
            : FluffyColors.shimmerHighlightLightAlt,
        child: Container(
          decoration: ShapeDecoration(
            color: FluffyColors.white,
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(shimmerBorderRadius ?? Spacing.d12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
