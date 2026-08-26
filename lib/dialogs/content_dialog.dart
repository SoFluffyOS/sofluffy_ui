import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class ContentDialog {
  static Future<ConfirmAction> show(
    BuildContext context, {
    String? title,
    required String content,
    String? negativeText,
    String? positiveText,
    String? neutralText,
    bool useHtmlWidget = false,
  }) async {
    final controller = ScrollController();
    try {
      final result = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
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
          void submitPrimaryAction() {
            if (positiveText != null) {
              context.navigator.pop(ConfirmAction.positive);
              return;
            }
            if (neutralText != null) {
              context.navigator.pop();
            }
          }

          final dialog = DialogCard(
            title: title != null ? Text(title) : null,
            content: RawScrollbar(
              controller: controller,
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (useHtmlWidget) HtmlWidget(content),
                    if (!useHtmlWidget) Text(content),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  if (negativeText case String negativeText)
                    Expanded(
                      child: Button(
                        tooltip: negativeText,
                        variant: ButtonVariant.ghost,
                        label: negativeText,
                        onPressed: () {
                          context.navigator.pop(ConfirmAction.negative);
                        },
                      ),
                    ),
                  if (negativeText != null && positiveText != null) Spacing.h8,
                  if (positiveText case String positiveText)
                    Expanded(
                      child: Button(
                        tooltip: positiveText,
                        variant: ButtonVariant.primary,
                        label: positiveText,
                        onPressed: () {
                          context.navigator.pop(ConfirmAction.positive);
                        },
                      ),
                    ),
                ],
              ),
              if (negativeText != null || positiveText != null) Spacing.v8,
              if (neutralText case String neutralText)
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        variant: ButtonVariant.primary,
                        tooltip: neutralText,
                        label: neutralText,
                        onPressed: () {
                          context.navigator.pop();
                        },
                      ),
                    ),
                  ],
                ),
            ],
          );

          return CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.enter):
                  submitPrimaryAction,
              const SingleActivator(LogicalKeyboardKey.numpadEnter):
                  submitPrimaryAction,
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
    } finally {
      controller.dispose();
    }
  }
}
