import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class UserWidget extends StatelessWidget {
  final String? avatarUrl;
  final String? avatarBlurHash;

  final String? name;
  final String? subText;

  const UserWidget({
    super.key,
    this.avatarUrl,
    this.avatarBlurHash,
    this.name,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    return Row(
      children: [
        if (avatarUrl != null) ...[
          ClipOval(
            child: ImageView(
              avatarUrl,
              fit: BoxFit.cover,
              blurHash: avatarBlurHash,
              size: Spacing.d36,
            ),
          ),
        ] else ...[
          Container(
            width: Spacing.d36,
            height: Spacing.d36,
            decoration: BoxDecoration(
              color: theme.colors.neutral3,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name?.isNotEmpty == true ? name![0].toUpperCase() : '?',
              style: TextStyle(
                color: theme.colors.neutral7,
                fontSize: Spacing.d16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        if (name case String name) ...[
          Spacing.h8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colors.neutral7,
                  ),
                ),
                if (subText case String subText) ...[
                  Text(
                    subText,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colors.neutral4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
