import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class StepperWidget extends StatelessWidget {
  final int stepCount;
  final int currentStep;

  final Color? activeColor;
  final Color? inactiveColor;

  const StepperWidget({
    super.key,
    required this.stepCount,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.fluffyTheme.colors.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < stepCount; i++)
          AnimatedContainer(
            duration: FluffyDurations.fast,
            width: Spacing.d8,
            height: Spacing.d8,
            margin: EdgeInsets.symmetric(
              horizontal: Spacing.d4,
            ),
            decoration: BoxDecoration(
              color: i <= currentStep
                  ? activeColor ?? primaryColor
                  : FluffyColors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
