import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class DialogCard extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;
  final double? maxWidth;
  final double? maxHeight;

  const DialogCard({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.contentPadding,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final isDesktop = switch (context.fluffyTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };

    final scaffoldBg = switch (isDark) {
      true => theme.colors.neutral7,
      false => theme.colors.neutral1,
    };
    final borderColor = switch (isDark) {
      true => theme.colors.neutral5,
      false => theme.colors.neutral3,
    };
    final screenSize = MediaQuery.sizeOf(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: switch (isDesktop) {
            true => Spacing.d32,
            false => Spacing.d16,
          },
          vertical: switch (isDesktop) {
            true => Spacing.d40,
            false => Spacing.d24,
          },
        ),
        child: RoundCard(
          padding: EdgeInsets.all(
            switch (isDesktop) {
              true => Spacing.d20,
              false => Spacing.d24,
            },
          ),
          color: scaffoldBg,
          borderColor: borderColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: switch (isDesktop) {
                true => Spacing.d320,
                false => Spacing.d280,
              },
              maxWidth: switch (maxWidth) {
                final w? => w,
                null => switch (isDesktop) {
                  true => Spacing.d360,
                  false => Spacing.d360,
                },
              },
              maxHeight: switch (maxHeight) {
                final h? => h,
                null => screenSize.height * 0.85,
              },
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title case final heading?) ...[
                  DefaultTextStyle(
                    style: theme.typography.headline6.copyWith(
                      color: switch (isDark) {
                        true => theme.colors.neutral1,
                        false => theme.colors.neutral7,
                      },
                      fontWeight: FontWeight.w600,
                    ),
                    child: heading,
                  ),
                  Spacing.v16,
                ],
                if (content case final body?) ...[
                  Flexible(
                    child: Padding(
                      padding: switch (contentPadding) {
                        final pad? => pad,
                        null => EdgeInsets.zero,
                      },
                      child: DefaultTextStyle(
                        style: theme.typography.base2.copyWith(
                          color: switch (isDark) {
                            true => theme.colors.neutral1,
                            false => theme.colors.neutral7,
                          },
                        ),
                        child: body,
                      ),
                    ),
                  ),
                ],
                if (actions case final buttons? when buttons.isNotEmpty) ...[
                  switch (isDesktop) {
                    true => Spacing.v16,
                    false => Spacing.v24,
                  },
                  ...buttons,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
