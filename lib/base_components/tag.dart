import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color color;

  final EdgeInsets? padding;

  const Tag(
    this.text, {
    super.key,
    this.color = Colors.white,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = switch (Theme.of(context).platform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };
    final resolvedPadding =
        padding ??
        (isDesktop
            ? EdgeInsets.symmetric(horizontal: Spacing.d6, vertical: Spacing.d2)
            : EdgeInsets.symmetric(
                horizontal: Spacing.d8,
                vertical: Spacing.d4,
              ));

    return Container(
      padding: resolvedPadding,
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.1),
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
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
