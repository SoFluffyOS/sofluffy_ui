import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      final result = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          final isDesktop = switch (Theme.of(context).platform) {
            TargetPlatform.macOS ||
            TargetPlatform.windows ||
            TargetPlatform.linux => true,
            _ => false,
          };
          final theme = context.theme;

          void submitPrimaryAction() {
            if (positiveText != null) {
              context.navigator.pop(ConfirmAction.positive);
              return;
            }
            if (neutralText != null) {
              context.navigator.pop();
            }
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
            title: title != null ? Text(title) : null,
            content: Scrollbar(
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
            actions: <Widget>[
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
