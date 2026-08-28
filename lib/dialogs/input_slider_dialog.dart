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
  }) async {
    final selectedValueNotifier = ValueNotifier<double>(initialValue ?? min);
    final fluffyTheme = context.fluffyTheme;
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
          final theme = context.fluffyTheme;

          void confirm() {
            context.navigator.pop(selectedValueNotifier.value);
          }

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
                          labelBuilder?.call(min) ?? min.toString(),
                          style: theme.typography.caption1,
                        ),
                        Spacing.h8,
                        Expanded(
                          child: _SimpleSlider(
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
                          labelBuilder?.call(max) ?? max.toString(),
                          style: theme.typography.caption1,
                        ),
                      ],
                    ),
                    if (hintBuilder != null) ...[
                      Spacing.v4,
                      Text(
                        hintBuilder(selectedValue),
                        style: theme.typography.caption1,
                      ),
                    ],
                  ],
                );
              },
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

class _SimpleSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _SimpleSlider({
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final fraction = (max > min)
            ? ((value - min) / (max - min)).clamp(0.0, 1.0)
            : 0.0;

        void updateFromPosition(double dx) {
          final newFraction = (dx / trackWidth).clamp(0.0, 1.0);
          double newValue = min + newFraction * (max - min);
          if (divisions != null && divisions! > 0) {
            final step = (max - min) / divisions!;
            newValue = (min + ((newValue - min) / step).round() * step).clamp(
              min,
              max,
            );
          }
          onChanged(newValue);
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) =>
              updateFromPosition(details.localPosition.dx),
          onTapDown: (details) => updateFromPosition(details.localPosition.dx),
          child: SizedBox(
            height: Spacing.d32,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: Spacing.d4,
                  width: trackWidth,
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colors.neutral5
                        : theme.colors.neutral3,
                    borderRadius: BorderRadius.circular(Spacing.d2),
                  ),
                ),
                Container(
                  height: Spacing.d4,
                  width: trackWidth * fraction,
                  decoration: BoxDecoration(
                    color: theme.colors.primary,
                    borderRadius: BorderRadius.circular(Spacing.d2),
                  ),
                ),
                Positioned(
                  left: (trackWidth * fraction - Spacing.d8).clamp(
                    0.0,
                    trackWidth - Spacing.d16,
                  ),
                  child: Container(
                    width: Spacing.d16,
                    height: Spacing.d16,
                    decoration: BoxDecoration(
                      color: theme.colors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: FluffyColors.shadow,
                          blurRadius: Spacing.d4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
