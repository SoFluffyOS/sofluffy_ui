import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

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
      final result = await showGeneralDialog(
        context: context,
        barrierDismissible: false,
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
          void confirm() {
            context.navigator.pop(controller.text);
          }

          final dialog = DialogCard(
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
            actions: [
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
