import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/base_components/color_picker/checkerboard.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// The color before and after: a click on [original] goes back to it, one
/// on the picked color, which shows [label], calls [onLabelTap].
class ColorPickerHeader extends StatelessWidget {
  const ColorPickerHeader({
    super.key,
    required this.color,
    required this.label,
    this.original,
    this.onRevert,
    this.onLabelTap,
    this.labelTooltip,
  });

  final Color color;

  /// The picked color as text, such as its hex or its code.
  final String label;
  final Color? original;
  final VoidCallback? onRevert;
  final VoidCallback? onLabelTap;
  final String? labelTooltip;

  /// Black or white, whichever reads better on [background].
  static Color legibleOn(Color background) {
    final isLight = background.a < 0.5 || background.computeLuminance() > 0.45;
    return switch (isLight) {
      true => const Color(0xff000000),
      false => const Color(0xffffffff),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final labelStyle = theme.typography.caption1.copyWith(
      color: legibleOn(color),
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return SizedBox(
      height: Spacing.d28,
      child: ClipRRect(
        borderRadius: Spacing.r6,
        child: CustomPaint(
          painter: CheckerboardPainter(square: Spacing.d6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (original case final original?)
                Expanded(
                  child: Tappable(
                    onTap: onRevert,
                    behavior: HitTestBehavior.opaque,
                    tooltip: 'Original color',
                    enableAnimation: false,
                    // Tappable lays its child out loosely: fill the space.
                    child: SizedBox.expand(child: ColoredBox(color: original)),
                  ),
                ),
              Expanded(
                flex: 3,
                child: Tappable(
                  onTap: onLabelTap,
                  behavior: HitTestBehavior.opaque,
                  tooltip: labelTooltip,
                  enableAnimation: false,
                  child: ColoredBox(
                    color: color,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Spacing.d8),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: labelStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
