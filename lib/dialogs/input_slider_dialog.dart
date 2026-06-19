import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputSliderDialog {
  static Future<double?> show(
    BuildContext context, {
    required String title,
    required String cancelText,
    required String confirmText,
    double? initialValue,
    int? divisions,
    required double min,
    required double max,
    String Function(double value)? labelBuilder,
    String Function(double value)? hintBuilder,
  }) async {
    final selectedValueNotifier = ValueNotifier<double>(initialValue ?? min);
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
            context.navigator.pop(selectedValueNotifier.value);
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
            content: ValueListenableBuilder(
              valueListenable: selectedValueNotifier,
              builder: (context, selectedValue, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          labelBuilder?.call(min) ?? min.toString(),
                          style: context.theme.textTheme.bodySmall,
                        ),
                        Expanded(
                          child: Slider(
                            label:
                                labelBuilder?.call(selectedValue) ??
                                selectedValue.toString(),
                            value: selectedValue,
                            divisions: divisions,
                            min: min,
                            max: max,
                            onChanged: (value) {
                              selectedValueNotifier.value = value;
                            },
                          ),
                        ),
                        Text(
                          labelBuilder?.call(max) ?? max.toString(),
                          style: context.theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (hintBuilder != null) ...[
                      Spacing.v4,
                      Text(
                        hintBuilder(selectedValue),
                        style: context.theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                );
              },
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Button(
                      variant: ButtonVariant.ghost,
                      tooltip: cancelText,
                      child: Flexible(
                        child: Text(
                          cancelText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
                      onPressed: confirm,
                      child: Flexible(
                        child: Text(
                          confirmText,
                          style: TextStyle(
                            color: context.theme.colorScheme.onPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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

      if (result is! double) {
        return null;
      }

      return result;
    } finally {
      selectedValueNotifier.dispose();
    }
  }
}
