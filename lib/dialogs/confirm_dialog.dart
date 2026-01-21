import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

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
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message case String message when message.isNotEmpty) ...[
                Text(
                  message,
                ),
              ],
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Button(
                    variant: ButtonVariant.ghost,
                    child: Text(negativeText),
                    onPressed: () {
                      context.navigator.pop(ConfirmAction.negative);
                    },
                  ),
                ),
                Spacing.h8,
                Expanded(
                  child: Button(
                    variant: ButtonVariant.primary,
                    child: Text(
                      positiveText,
                      style: TextStyle(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () {
                      context.navigator.pop(ConfirmAction.positive);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result is! ConfirmAction) {
      return ConfirmAction.dismiss;
    }

    return result;
  }
}
