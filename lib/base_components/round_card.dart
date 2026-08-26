import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class RoundCard extends StatelessWidget {
  final Widget child;

  final double? borderRadius;

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
    this.borderRadius,
    this.margin,
    this.padding,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final defaultCardColor = context.isDark
        ? context.fluffyTheme.colors.neutral6
        : context.fluffyTheme.colors.neutral2;
    return Container(
      margin: margin,
      padding: padding,
      decoration: ShapeDecoration(
        color: color ?? defaultCardColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: switch (borderRadius) {
            final borderRadius? => BorderRadius.all(
              Radius.circular(borderRadius),
            ),
            _ => Spacing.r12,
          },
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
