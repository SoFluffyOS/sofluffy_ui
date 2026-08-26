import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color color;

  final EdgeInsets? padding;

  const Tag(
    this.text, {
    super.key,
    this.color = FluffyColors.white,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = switch (defaultTargetPlatform) {
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
          borderRadius: Spacing.r12,
          side: BorderSide(
            color: FluffyColors.transparent,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
      ),
      child: Text(
        text,
        style: context.fluffyTheme.typography.caption2.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
