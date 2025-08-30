part of 'check_box.dart';

enum CheckBoxAlignment {
  left,
  right,
}

enum CheckBoxListTileStyle {
  compact,
  standard,
}

class CheckBoxListTile extends StatelessWidget {
  final CheckBoxAlignment alignment;
  final CheckBoxListTileStyle style;

  final bool value;
  final ValueChanged<bool> onChanged;

  final String? title;
  final String? subtitle;
  final Widget? child;

  const CheckBoxListTile({
    super.key,
    this.alignment = CheckBoxAlignment.left,
    this.style = CheckBoxListTileStyle.standard,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.child,
  }) : assert(
         subtitle == null || style != CheckBoxListTileStyle.compact,
         'Not allow [subtitle] when using [CheckBoxListTileStyle.compact]',
       );

  @override
  Widget build(BuildContext context) {
    final spacer = switch (style) {
      CheckBoxListTileStyle.compact => const SizedBox.shrink(),
      CheckBoxListTileStyle.standard => Spacing.h8,
    };
    final titleWidget = switch (title) {
      String title when title.isNotEmpty => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: switch (style) {
              CheckBoxListTileStyle.compact =>
                context.theme.textTheme.bodySmall,
              CheckBoxListTileStyle.standard =>
                context.theme.textTheme.bodyLarge,
            },
          ),
          if (subtitle case String subtitle when subtitle.isNotEmpty) ...[
            Spacing.v4,
            Text(
              subtitle,
              style: context.theme.textTheme.bodySmall,
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
      onTap: () => onChanged(!value),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: switch (style) {
            CheckBoxListTileStyle.compact => Spacing.d4,
            CheckBoxListTileStyle.standard => Spacing.d8,
          },
          horizontal: switch (style) {
            CheckBoxListTileStyle.compact => 0.0,
            CheckBoxListTileStyle.standard => Spacing.d16,
          },
        ),
        child: Row(
          mainAxisSize: switch (style) {
            CheckBoxListTileStyle.compact => MainAxisSize.min,
            CheckBoxListTileStyle.standard => MainAxisSize.max,
          },
          children: [
            if (titleWidget != null &&
                alignment == CheckBoxAlignment.right) ...[
              Expanded(child: titleWidget),
              spacer,
            ],
            CheckBox(
              value: value,
              onChanged: onChanged,
            ),
            if (titleWidget != null && alignment == CheckBoxAlignment.left) ...[
              spacer,
              Flexible(child: titleWidget),
            ],
          ],
        ),
      ),
    );
  }
}
