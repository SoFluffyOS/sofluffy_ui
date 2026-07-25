import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final result = await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        final isDesktop = switch (Theme.of(context).platform) {
          TargetPlatform.macOS ||
          TargetPlatform.windows ||
          TargetPlatform.linux => true,
          _ => false,
        };
        final theme = context.theme;

        final dialog = AlertDialog(
          shape: isDesktop
              ? SmoothRectangleBorder(
                  borderRadius: Spacing.smoothR12,
                  side: BorderSide(color: theme.dividerColor, width: 0.25),
                )
              : null,
          backgroundColor: isDesktop ? theme.scaffoldBackgroundColor : null,
          elevation: isDesktop ? 0 : null,
          title: Text(title),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 360 : double.infinity,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message case String message when message.isNotEmpty) ...[
                  Text(
                    message,
                  ),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Button(
                    variant: ButtonVariant.ghost,
                    tooltip: negativeText,
                    label: negativeText,
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
                    onPressed: () {
                      context.navigator.pop(ConfirmAction.positive);
                    },
                  ),
                ),
              ],
            ),
          ],
        );

        return CallbackShortcuts(
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
        );
      },
    );

    if (result is! ConfirmAction) {
      return ConfirmAction.dismiss;
    }

    return result;
  }
}
