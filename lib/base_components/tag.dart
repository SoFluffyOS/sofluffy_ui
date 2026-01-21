import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color color;

  const Tag(this.text, {super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d8,
        vertical: Spacing.d4,
      ),
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.1),
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 12.0, cornerSmoothing: 1.0),
          ),
          side: BorderSide(
            color: Colors.transparent,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
      ),
      child: Text(
        text,
        style: context.theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
