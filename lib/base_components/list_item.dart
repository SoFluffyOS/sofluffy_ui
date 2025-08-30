import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum ListItemStyle {
  compact,
  standard,
}

class ListItem extends StatelessWidget {
  final ListItemStyle style;

  final Widget? leading;
  final Widget? trailing;

  final String? title;
  final String? subtitle;
  final Widget? child;

  final VoidCallback? onTap;

  const ListItem({
    super.key,
    this.style = ListItemStyle.standard,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.child,
    this.onTap,
  }) : assert(
         subtitle == null || style != ListItemStyle.compact,
         'Not allow [subtitle] when using [ListItemStyle.compact]',
       );

  @override
  Widget build(BuildContext context) {
    final spacer = switch (style) {
      ListItemStyle.compact => const SizedBox.shrink(),
      ListItemStyle.standard => Spacing.h8,
    };
    final titleWidget = switch (title) {
      String title when title.isNotEmpty => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: switch (style) {
              ListItemStyle.compact => context.theme.textTheme.bodySmall,
              ListItemStyle.standard => context.theme.textTheme.bodyLarge,
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
      enableAnimation: true,
      enableHover: true,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: switch (style) {
            ListItemStyle.compact => Spacing.d4,
            ListItemStyle.standard => Spacing.d8,
          },
          horizontal: switch (style) {
            ListItemStyle.compact => 0.0,
            ListItemStyle.standard => Spacing.d16,
          },
        ),
        child: Row(
          mainAxisSize: switch (style) {
            ListItemStyle.compact => MainAxisSize.min,
            ListItemStyle.standard => MainAxisSize.max,
          },
          children: [
            if (leading case Widget leading) ...[
              leading,
              spacer,
            ],
            if (titleWidget != null) ...[
              switch (style) {
                ListItemStyle.compact => Flexible(child: titleWidget),
                ListItemStyle.standard => Expanded(child: titleWidget),
              },
            ],
            if (trailing case Widget trailing) ...[
              spacer,
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}
