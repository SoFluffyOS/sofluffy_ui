import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

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
    String barrierLabel = 'Dismiss',
  }) async {
    final selectedValueNotifier = ValueNotifier<double>(initialValue ?? min);
    final fluffyTheme = context.fluffyTheme;
    try {
      final result = await showGeneralDialog(
        context: context,
        barrierDismissible: false,
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
          final theme = fluffyTheme;

          void confirm() {
            context.navigator.pop(selectedValueNotifier.value);
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
            content: ValueListenableBuilder(
              valueListenable: selectedValueNotifier,
              builder: (context, selectedValue, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          switch (labelBuilder?.call(min)) {
                            final label? => label,
                            null => min.toString(),
                          },
                          style: theme.typography.caption1,
                        ),
                        Spacing.h8,
                        Expanded(
                          child: FluffySlider(
                            value: selectedValue,
                            min: min,
                            max: max,
                            divisions: divisions,
                            onChanged: (value) {
                              selectedValueNotifier.value = value;
                            },
                          ),
                        ),
                        Spacing.h8,
                        Text(
                          switch (labelBuilder?.call(max)) {
                            final label? => label,
                            null => max.toString(),
                          },
                          style: theme.typography.caption1,
                        ),
                      ],
                    ),
                    if (hintBuilder case final hint?) ...[
                      Spacing.v8,
                      Text(
                        hint(selectedValue),
                        style: theme.typography.caption1,
                      ),
                    ],
                  ],
                );
              },
            ),
            actions: [
              Row(
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
                      variant: ButtonVariant.primary,
                      tooltip: confirmText,
                      label: confirmText,
                      mainAxisSize: MainAxisSize.min,
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.d16,
                        vertical: Spacing.d8,
                      ),
                      onPressed: confirm,
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
                        variant: ButtonVariant.primary,
                        tooltip: confirmText,
                        label: confirmText,
                        titleExpand: ButtonTitleExpand.shrink,
                        onPressed: confirm,
                      ),
                    ),
                  ],
                },
              ),
            ],
          );

          return FluffyTheme(
            data: fluffyTheme,
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter): confirm,
                const SingleActivator(LogicalKeyboardKey.numpadEnter): confirm,
              },
              child: Focus(
                autofocus: true,
                child: dialog,
              ),
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
