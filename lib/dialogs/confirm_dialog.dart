import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

enum ConfirmAction { positive, negative, dismiss }

class ConfirmDialog {
  static Future<ConfirmAction> show(
    BuildContext context, {
    required String title,
    String? message,
    required String negativeText,
    required String positiveText,
    bool barrierDismissible = true,
  }) async {
    final fluffyTheme = context.fluffyTheme;
    final result = await showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: FluffyColors.barrier,
      transitionDuration: FluffyDurations.dialogTransition,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (BuildContext context, anim1, anim2) {
        final targetPlatform = fluffyTheme.platform ?? defaultTargetPlatform;
        final isDesktop = switch (targetPlatform) {
          TargetPlatform.macOS ||
          TargetPlatform.windows ||
          TargetPlatform.linux => true,
          _ => false,
        };

        final dialog = DialogCard(
          title: Text(title),
          content: switch (message) {
            final m? when m.isNotEmpty => Text(m),
            _ => null,
          },
          actions: [
            Row(
              mainAxisAlignment: switch (isDesktop) {
                true => MainAxisAlignment.end,
                false => MainAxisAlignment.center,
              },
              children: switch (isDesktop) {
                true => [
                  Button(
                    variant: ButtonVariant.ghost,
                    tooltip: negativeText,
                    label: negativeText,
                    mainAxisSize: MainAxisSize.min,
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.d16,
                      vertical: Spacing.d8,
                    ),
                    onPressed: () {
                      context.navigator.pop(ConfirmAction.negative);
                    },
                  ),
                  Spacing.h8,
                  Button(
                    variant: ButtonVariant.primary,
                    tooltip: positiveText,
                    label: positiveText,
                    mainAxisSize: MainAxisSize.min,
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.d16,
                      vertical: Spacing.d8,
                    ),
                    onPressed: () {
                      context.navigator.pop(ConfirmAction.positive);
                    },
                  ),
                ],
                false => [
                  Expanded(
                    child: Button(
                      variant: ButtonVariant.ghost,
                      tooltip: negativeText,
                      label: negativeText,
                      titleExpand: ButtonTitleExpand.shrink,
                      onPressed: () {
                        context.navigator.pop(ConfirmAction.negative);
                      },
                    ),
                  ),
                  Spacing.h8,
                  Expanded(
                    child: Button(
                      variant: ButtonVariant.primary,
                      tooltip: positiveText,
                      label: positiveText,
                      titleExpand: ButtonTitleExpand.shrink,
                      onPressed: () {
                        context.navigator.pop(ConfirmAction.positive);
                      },
                    ),
                  ),
                ],
              },
            ),
          ],
        );

        return FluffyTheme(
          data: fluffyTheme,
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.enter): () {
                context.navigator.pop(ConfirmAction.positive);
              },
              const SingleActivator(LogicalKeyboardKey.numpadEnter): () {
                context.navigator.pop(ConfirmAction.positive);
              },
            },
            child: Focus(
              autofocus: true,
              child: dialog,
            ),
          ),
        );
      },
    );

    if (result is! ConfirmAction) {
      return ConfirmAction.dismiss;
    }

    return result;
  }
}
