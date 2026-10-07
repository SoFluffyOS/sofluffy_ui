import 'package:flutter/foundation.dart';
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
    String barrierLabel = 'Dismiss',
  }) async {
    final controller = ScrollController();
    final fluffyTheme = context.fluffyTheme;
    try {
      final result = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: barrierLabel,
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

          final targetPlatform = fluffyTheme.platform ?? defaultTargetPlatform;
          final isDesktop = switch (targetPlatform) {
            TargetPlatform.macOS ||
            TargetPlatform.windows ||
            TargetPlatform.linux => true,
            _ => false,
          };

          final dialog = DialogCard(
            title: switch (title) {
              final t? => Text(t),
              null => null,
            },
            content: RawScrollbar(
              controller: controller,
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    switch (useHtmlWidget) {
                      true => HtmlWidget(content),
                      false => Text(content),
                    },
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: switch (isDesktop) {
                  true => MainAxisAlignment.end,
                  false => MainAxisAlignment.center,
                },
                children: [
                  if (negativeText case final neg?)
                    switch (isDesktop) {
                      true => Button(
                        tooltip: neg,
                        variant: ButtonVariant.ghost,
                        label: neg,
                        mainAxisSize: MainAxisSize.min,
                        padding: EdgeInsets.symmetric(
                          horizontal: Spacing.d16,
                          vertical: Spacing.d8,
                        ),
                        onPressed: () {
                          context.navigator.pop(ConfirmAction.negative);
                        },
                      ),
                      false => Expanded(
                        child: Button(
                          tooltip: neg,
                          variant: ButtonVariant.ghost,
                          label: neg,
                          titleExpand: ButtonTitleExpand.shrink,
                          onPressed: () {
                            context.navigator.pop(ConfirmAction.negative);
                          },
                        ),
                      ),
                    },
                  if (negativeText != null && positiveText != null) Spacing.h8,
                  if (positiveText case final pos?)
                    switch (isDesktop) {
                      true => Button(
                        tooltip: pos,
                        variant: ButtonVariant.primary,
                        label: pos,
                        mainAxisSize: MainAxisSize.min,
                        padding: EdgeInsets.symmetric(
                          horizontal: Spacing.d16,
                          vertical: Spacing.d8,
                        ),
                        onPressed: () {
                          context.navigator.pop(ConfirmAction.positive);
                        },
                      ),
                      false => Expanded(
                        child: Button(
                          tooltip: pos,
                          variant: ButtonVariant.primary,
                          label: pos,
                          titleExpand: ButtonTitleExpand.shrink,
                          onPressed: () {
                            context.navigator.pop(ConfirmAction.positive);
                          },
                        ),
                      ),
                    },
                ],
              ),
              if (negativeText != null || positiveText != null) Spacing.v8,
              if (neutralText case final neutral?)
                Row(
                  mainAxisAlignment: switch (isDesktop) {
                    true => MainAxisAlignment.end,
                    false => MainAxisAlignment.center,
                  },
                  children: [
                    switch (isDesktop) {
                      true => Button(
                        variant: ButtonVariant.primary,
                        tooltip: neutral,
                        label: neutral,
                        mainAxisSize: MainAxisSize.min,
                        padding: EdgeInsets.symmetric(
                          horizontal: Spacing.d16,
                          vertical: Spacing.d8,
                        ),
                        onPressed: () {
                          context.navigator.pop();
                        },
                      ),
                      false => Expanded(
                        child: Button(
                          variant: ButtonVariant.primary,
                          tooltip: neutral,
                          label: neutral,
                          titleExpand: ButtonTitleExpand.shrink,
                          onPressed: () {
                            context.navigator.pop();
                          },
                        ),
                      ),
                    },
                  ],
                ),
            ],
          );

          return FluffyTheme(
            data: fluffyTheme,
            child: CallbackShortcuts(
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
