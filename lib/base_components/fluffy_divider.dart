import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// A thin line between sections, centered across the space it takes.
///
/// [FluffyDivider] runs across its parent's width; [FluffyDivider.vertical]
/// runs down its parent's height.
class FluffyDivider extends StatelessWidget {
  /// A horizontal line, centered in [extent] of height.
  const FluffyDivider({
    super.key,
    this.extent,
    this.thickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  }) : axis = Axis.horizontal;

  /// A vertical line, centered in [extent] of width.
  const FluffyDivider.vertical({
    super.key,
    this.extent,
    this.thickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  }) : axis = Axis.vertical;

  /// The direction the line runs in.
  final Axis axis;

  /// The space across the line, which it is centered in. Defaults to
  /// [Spacing.d16].
  final double? extent;

  /// Defaults to [Spacing.d1].
  final double? thickness;

  /// The gap before the line's start: its leading edge when horizontal,
  /// its top when vertical.
  final double indent;

  /// The gap after the line's end.
  final double endIndent;

  /// Defaults to a neutral that reads on the theme's background.
  final Color? color;

  /// The line color when none is given.
  static Color defaultColor(BuildContext context) {
    final colors = context.fluffyTheme.colors;
    return switch (context.isDark) {
      true => colors.neutral4,
      false => colors.neutral3,
    };
  }

  @override
  Widget build(BuildContext context) {
    final extent = this.extent ?? Spacing.d16;
    final thickness = this.thickness ?? Spacing.d1;
    final color = this.color ?? defaultColor(context);

    final line = ColoredBox(color: color);

    return switch (axis) {
      Axis.horizontal => SizedBox(
        height: extent,
        child: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: indent, end: endIndent),
            child: SizedBox(
              height: thickness,
              width: double.infinity,
              child: line,
            ),
          ),
        ),
      ),
      Axis.vertical => SizedBox(
        width: extent,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: indent, bottom: endIndent),
            child: SizedBox(
              width: thickness,
              height: double.infinity,
              child: line,
            ),
          ),
        ),
      ),
    };
  }
}
