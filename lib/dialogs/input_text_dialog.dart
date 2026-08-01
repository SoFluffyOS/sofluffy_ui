import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextDialog {
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String labelText,
    String? hintText,
    required String cancelText,
    required String confirmText,
    String initialValue = '',
  }) async {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );

    try {
      final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final isDesktop = switch (Theme.of(context).platform) {
            TargetPlatform.macOS ||
            TargetPlatform.windows ||
            TargetPlatform.linux => true,
            _ => false,
          };
          final theme = context.theme;

          void confirm() {
            context.navigator.pop(controller.text);
          }

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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputText(
                  controller: controller,
                  label: labelText,
                  hintText: hintText,
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Button(
                      variant: ButtonVariant.ghost,
                      tooltip: cancelText,
                      label: cancelText,
                      onPressed: () {
                        context.navigator.pop();
                      },
                    ),
                  ),
                  Spacing.h8,
                  Expanded(
                    child: Button(
                      variant: ButtonVariant.primary,
                      tooltip: confirmText,
                      label: confirmText,
                      onPressed: confirm,
                    ),
                  ),
                ],
              ),
            ],
          );

          return CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.enter): confirm,
              const SingleActivator(LogicalKeyboardKey.numpadEnter): confirm,
            },
            child: Focus(
              autofocus: true,
              child: dialog,
            ),
          );
        },
      );

      if (result is! String) {
        return null;
      }

      return result;
    } finally {
      controller.dispose();
    }
  }
}
