import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  }) async {
    final ValueNotifier<T?> notifier = ValueNotifier(initialValue);
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

          final dialog = AlertDialog(
            constraints: isDesktop ? const BoxConstraints(maxWidth: 360) : null,
            shape: isDesktop
                ? RoundedSuperellipseBorder(
                    borderRadius: Spacing.r12,
                    side: BorderSide(color: theme.dividerColor, width: 0.25),
                  )
                : null,
            backgroundColor: isDesktop ? theme.scaffoldBackgroundColor : null,
            elevation: isDesktop ? 0 : null,
            title: Text(title),
            contentPadding: EdgeInsets.only(
              top: Spacing.d16,
              bottom: Spacing.d24,
            ),
            content: ConstrainedBox(
              key: const ValueKey('radio-options-dialog-content'),
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 360 : double.infinity,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message case String message when message.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.d24,
                      ),
                      child: switch (useHtmlMessage) {
                        true => HtmlWidget(
                          message,
                          textStyle: TextStyle(
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                        false => Text(
                          message,
                          style: TextStyle(
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      },
                    ),
                    Spacing.v16,
                  ],
                  ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (context, groupValue, child) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: Spacing.d24,
                        ),
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
            ),
            actions: <Widget>[
              ValueListenableBuilder(
                valueListenable: notifier,
                builder: (context, groupValue, child) {
                  return Row(
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
                          enable: groupValue != null,
                          variant: ButtonVariant.primary,
                          tooltip: confirmText,
                          label: confirmText,
                          onPressed: () {
                            confirmSelected();
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );

          return CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.enter): confirmSelected,
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
