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

  final String? label;
  final Widget? child;

  const CheckBoxListTile({
    super.key,
    this.alignment = CheckBoxAlignment.right,
    this.style = CheckBoxListTileStyle.standard,
    required this.value,
    required this.onChanged,
    this.label,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final spacer = switch (style) {
      CheckBoxListTileStyle.compact => const SizedBox.shrink(),
      CheckBoxListTileStyle.standard => Spacing.h8,
    };
    final labelWidget = switch (label) {
      String label when label.isNotEmpty => Text(
        label,
        style: switch (style) {
          CheckBoxListTileStyle.compact => context.theme.textTheme.bodySmall,
          CheckBoxListTileStyle.standard => context.theme.textTheme.bodyLarge,
        },
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
        ),
        child: Row(
          children: [
            if (labelWidget != null &&
                alignment == CheckBoxAlignment.right) ...[
              Expanded(child: labelWidget),
              spacer,
            ],
            CheckBox(
              value: value,
              onChanged: onChanged,
            ),
            if (labelWidget != null && alignment == CheckBoxAlignment.left) ...[
              spacer,
              Flexible(child: labelWidget),
            ],
          ],
        ),
      ),
    );
  }
}
