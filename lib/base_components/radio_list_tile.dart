part of 'radio_icon.dart';

enum RadioIconAlignment {
  left,
  right,
}

enum RadioIconListTileStyle {
  compact,
  standard,
}

class RadioIconListTile<T> extends StatelessWidget {
  final RadioIconAlignment alignment;
  final RadioIconListTileStyle style;

  final T value;
  final T? groupValue;
  final ValueChanged<T> onChanged;

  final String? title;
  final String? subtitle;
  final Widget? child;

  final bool? expanded;

  const RadioIconListTile({
    super.key,
    this.alignment = RadioIconAlignment.left,
    this.style = RadioIconListTileStyle.standard,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.expanded,
    this.child,
  }) : assert(
         subtitle == null || style != RadioIconListTileStyle.compact,
         'Not allow [subtitle] when using [RadioIconListTileStyle.compact]',
       );

  @override
  Widget build(BuildContext context) {
    final spacer = switch (style) {
      RadioIconListTileStyle.compact => const SizedBox.shrink(),
      RadioIconListTileStyle.standard => Spacing.h8,
    };
    final titleWidget = switch (title) {
      String title when title.isNotEmpty => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: switch (style) {
              RadioIconListTileStyle.compact =>
                context.fluffyTheme.typography.caption1,
              RadioIconListTileStyle.standard =>
                context.fluffyTheme.typography.base1,
            },
          ),
          if (subtitle case String subtitle when subtitle.isNotEmpty) ...[
            Spacing.v4,
            Text(
              subtitle,
              style: context.fluffyTheme.typography.caption2,
            ),
          ],
        ],
      ),
      null when child is Widget => child,
      _ => null,
    };
    return Tappable(
      behavior: HitTestBehavior.translucent,
      enableAnimation: false,
      enableHover: false,
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: switch (style) {
            RadioIconListTileStyle.compact => Spacing.d4,
            RadioIconListTileStyle.standard => Spacing.d8,
          },
          horizontal: switch (style) {
            RadioIconListTileStyle.compact => 0.0,
            RadioIconListTileStyle.standard => Spacing.d16,
          },
        ),
        child: Row(
          mainAxisSize: switch (style) {
            RadioIconListTileStyle.compact when expanded == true =>
              MainAxisSize.max,
            RadioIconListTileStyle.compact => MainAxisSize.min,
            RadioIconListTileStyle.standard => MainAxisSize.max,
          },
          children: [
            if (titleWidget != null &&
                alignment == RadioIconAlignment.right) ...[
              Expanded(child: titleWidget),
              spacer,
            ],
            RadioIcon<T>(
              groupValue: groupValue,
              value: value,
              onChanged: onChanged,
            ),
            if (titleWidget != null &&
                alignment == RadioIconAlignment.left) ...[
              spacer,
              Flexible(child: titleWidget),
            ],
          ],
        ),
      ),
    );
  }
}
