import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < stepCount; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: Spacing.d8,
            height: Spacing.d8,
            margin: EdgeInsets.symmetric(
              horizontal: Spacing.d4,
            ),
            decoration: BoxDecoration(
              color: i < currentStep
                  ? activeColor ?? context.theme.colorScheme.primary
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
