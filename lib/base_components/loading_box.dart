import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: size ?? width,
      height: size ?? height,
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(shimmerBorderRadius ?? 12.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
