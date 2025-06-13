import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

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
          SizedBox.square(
            dimension: Spacing.d36,
            child: CircleAvatar(
              child: Icon(
                Icons.person,
                size: Spacing.d24,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subText case String subText) ...[
                  Text(
                    subText,
                    style: const TextStyle(
                      fontSize: 12,
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
