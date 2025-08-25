import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageView(
          icon,
          size: Spacing.d72,
          color: context.theme.colorScheme.primary,
        ),
        Spacing.v16,
        Text(
          title,
          style: context.theme.textTheme.titleSmall,
        ),
        if (subtitle case String subtitle when subtitle.isNotEmpty)
          Text(
            subtitle,
            style: context.theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}
