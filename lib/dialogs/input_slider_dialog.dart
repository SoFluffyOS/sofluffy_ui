import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

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
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final ValueNotifier<double> selectedValueNotifier = ValueNotifier(
          initialValue ?? min,
        );
        return AlertDialog(
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
                    onPressed: () {
                      context.navigator.pop(selectedValueNotifier.value);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result is! double) {
      return null;
    }

    return result;
  }
}
