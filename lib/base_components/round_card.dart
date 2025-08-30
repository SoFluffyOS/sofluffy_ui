import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';

class RoundCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const RoundCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: ShapeDecoration(
        color: context.theme.cardColor,
        shape: SmoothRectangleBorder(
          borderRadius: Spacing.smoothR12,
        ),
      ),
      child: child,
    );
  }
}
