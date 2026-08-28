import 'package:flutter/foundation.dart';
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

    final scaffoldBg = isDark ? theme.colors.neutral7 : theme.colors.neutral1;
    final borderColor = isDark ? theme.colors.neutral5 : theme.colors.neutral3;
    final screenSize = MediaQuery.sizeOf(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? Spacing.d32 : Spacing.d16,
          vertical: isDesktop ? Spacing.d40 : Spacing.d24,
        ),
        child: RoundCard(
          padding: EdgeInsets.all(Spacing.d24),
          color: scaffoldBg,
          borderColor: borderColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? (isDesktop ? 440 : 360),
              maxHeight: maxHeight ?? (screenSize.height * 0.85),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  DefaultTextStyle(
                    style: theme.typography.headline6.copyWith(
                      color: isDark
                          ? theme.colors.neutral1
                          : theme.colors.neutral7,
                      fontWeight: FontWeight.w600,
                    ),
                    child: title!,
                  ),
                  Spacing.v16,
                ],
                if (content != null) ...[
                  Flexible(
                    child: Padding(
                      padding: contentPadding ?? EdgeInsets.zero,
                      child: DefaultTextStyle(
                        style: theme.typography.base2.copyWith(
                          color: isDark
                              ? theme.colors.neutral1
                              : theme.colors.neutral7,
                        ),
                        child: content!,
                      ),
                    ),
                  ),
                ],
                if (actions != null && actions!.isNotEmpty) ...[
                  Spacing.v24,
                  ...actions!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
