import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

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
    final result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          contentPadding: EdgeInsets.only(
            top: Spacing.d16,
            bottom: Spacing.d24,
          ),
          content: Column(
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
          actions: <Widget>[
            ValueListenableBuilder(
              valueListenable: notifier,
              builder: (context, groupValue, child) {
                return Row(
                  children: [
                    Expanded(
                      child: Button(
                        variant: ButtonVariant.ghost,
                        child: Text(cancelText),
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
                        child: Text(
                          confirmText,
                          style: TextStyle(
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                        onPressed: () {
                          context.navigator.pop(groupValue);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );

    if (result is! T) {
      return null;
    }

    return result;
  }
}
