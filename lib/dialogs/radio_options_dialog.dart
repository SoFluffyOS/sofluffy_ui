import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class RadioOptionsDialog {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String? message,
    bool useHtmlMessage = false,
    required String cancelText,
    required String confirmText,
    T? initialValue,
    List<T> values = const [],
    required String Function(T) itemLabelBuilder,
    String barrierLabel = 'Dismiss',
  }) async {
    final ValueNotifier<T?> notifier = ValueNotifier(initialValue);
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
          final isDark = fluffyTheme.isDark;
          final onSurfaceColor = isDark
              ? fluffyTheme.colors.neutral1
              : fluffyTheme.colors.neutral7;

          void confirmSelected() {
            final value = notifier.value;
            if (value == null) return;
            context.navigator.pop(value);
          }

          void moveSelection(int delta) {
            if (values.isEmpty) return;

            final current = notifier.value;
            final currentIndex = current == null ? -1 : values.indexOf(current);
            final startIndex = switch (currentIndex) {
              >= 0 => currentIndex,
              _ when delta > 0 => -1,
              _ => 0,
            };
            notifier.value = values[(startIndex + delta) % values.length];
          }

          final targetPlatform = fluffyTheme.platform ?? defaultTargetPlatform;
          final isDesktop = switch (targetPlatform) {
            TargetPlatform.macOS ||
            TargetPlatform.windows ||
            TargetPlatform.linux => true,
            _ => false,
          };

          final dialog = DialogCard(
            title: Text(title),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message case String message when message.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: Spacing.d16),
                    child: switch (useHtmlMessage) {
                      true => HtmlWidget(
                        message,
                        textStyle: TextStyle(
                          color: onSurfaceColor,
                        ),
                      ),
                      false => Text(
                        message,
                        style: TextStyle(
                          color: onSurfaceColor,
                        ),
                      ),
                    },
                  ),
                ],
                ValueListenableBuilder(
                  valueListenable: notifier,
                  builder: (context, groupValue, child) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final value in values)
                            RadioIconListTile<T>(
                              style: RadioIconListTileStyle.compact,
                              expanded: true,
                              value: value,
                              groupValue: groupValue,
                              onChanged: (value) {
                                notifier.value = value;
                              },
                              title: itemLabelBuilder(value),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              ValueListenableBuilder(
                valueListenable: notifier,
                builder: (context, groupValue, child) {
                  return Row(
                    mainAxisAlignment: switch (isDesktop) {
                      true => MainAxisAlignment.end,
                      false => MainAxisAlignment.center,
                    },
                    children: switch (isDesktop) {
                      true => [
                        Button(
                          variant: ButtonVariant.ghost,
                          tooltip: cancelText,
                          label: cancelText,
                          mainAxisSize: MainAxisSize.min,
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.d16,
                            vertical: Spacing.d8,
                          ),
                          onPressed: () {
                            context.navigator.pop();
                          },
                        ),
                        Spacing.h8,
                        Button(
                          enable: groupValue != null,
                          variant: ButtonVariant.primary,
                          tooltip: confirmText,
                          label: confirmText,
                          mainAxisSize: MainAxisSize.min,
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.d16,
                            vertical: Spacing.d8,
                          ),
                          onPressed: () {
                            confirmSelected();
                          },
                        ),
                      ],
                      false => [
                        Expanded(
                          child: Button(
                            variant: ButtonVariant.ghost,
                            tooltip: cancelText,
                            label: cancelText,
                            titleExpand: ButtonTitleExpand.shrink,
                            onPressed: () {
                              context.navigator.pop();
                            },
                          ),
                        ),
                        Spacing.h8,
                        Expanded(
                          child: Button(
                            enable: groupValue != null,
                            variant: ButtonVariant.primary,
                            tooltip: confirmText,
                            label: confirmText,
                            titleExpand: ButtonTitleExpand.shrink,
                            onPressed: () {
                              confirmSelected();
                            },
                          ),
                        ),
                      ],
                    },
                  );
                },
              ),
            ],
          );

          return FluffyTheme(
            data: fluffyTheme,
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter):
                    confirmSelected,
                const SingleActivator(LogicalKeyboardKey.numpadEnter):
                    confirmSelected,
                const SingleActivator(LogicalKeyboardKey.arrowUp): () {
                  moveSelection(-1);
                },
                const SingleActivator(LogicalKeyboardKey.arrowDown): () {
                  moveSelection(1);
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

      if (result is! T) {
        return null;
      }

      return result;
    } finally {
      notifier.dispose();
    }
  }
}
