import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';

class RoundCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final Color? color;
  final Color? borderColor;

  final List<BoxShadow>? shadow;

  const RoundCard({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.margin,
    this.padding,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: ShapeDecoration(
        color: color ?? context.theme.cardColor,
        shape: SmoothRectangleBorder(
          borderRadius: Spacing.smoothR12,
          side: switch (borderColor) {
            final Color borderColor => BorderSide(color: borderColor),
            _ => BorderSide.none,
          },
        ),
        shadows: shadow,
      ),
      child: child,
    );
  }
}
