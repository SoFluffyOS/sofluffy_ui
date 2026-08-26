import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class EmptyWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;

  const EmptyWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageView(
          icon,
          size: Spacing.d72,
          color: theme.colors.primary,
        ),
        Spacing.v16,
        Text(
          title,
          style: theme.typography.headline6,
        ),
        if (subtitle case String subtitle when subtitle.isNotEmpty)
          Text(
            subtitle,
            style: theme.typography.caption1,
          ),
      ],
    );
  }
}
