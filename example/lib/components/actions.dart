import 'package:flutter/material.dart' show Icon, Icons;
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Button', type: Button, path: '[Actions]')
Widget buttonUseCase(BuildContext context) {
  final variant = context.knobs.object.segmented(
    label: 'Variant',
    options: ButtonVariant.values,
    initialOption: ButtonVariant.primary,
    labelBuilder: (value) => value.name,
  );
  final hasIcon = context.knobs.boolean(
    label: 'Show Icon',
    initialValue: false,
  );
  final hasTrailing = context.knobs.boolean(
    label: 'Show Trailing Icon',
    initialValue: false,
  );

  return Center(
    child: Button(
      variant: variant,
      enable: context.knobs.boolean(label: 'Enabled', initialValue: true),
      label: context.knobs.string(
        label: 'Label',
        initialValue: 'Action Button',
      ),
      tooltip: context.knobs.string(
        label: 'Tooltip',
        initialValue: 'Fluffy Button Tooltip',
      ),
      radius: context.knobs.double.slider(
        label: 'Border Radius',
        initialValue: 12.0,
        max: 40.0,
      ),
      icon: hasIcon
          ? const Icon(
              Icons.touch_app_rounded,
              size: 18,
            )
          : null,
      trailingIcon: hasTrailing
          ? const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
            )
          : null,
      onPressed: () {},
    ),
  );
}

@UseCase(name: 'RoundButton', type: RoundButton, path: '[Actions]')
Widget roundButtonUseCase(BuildContext context) {
  return Center(
    child: RoundButton(
      enable: context.knobs.boolean(label: 'Enabled', initialValue: true),
      tooltip: context.knobs.string(
        label: 'Tooltip',
        initialValue: 'Round Action Button',
      ),
      icon: Icons.add_rounded,
      onPressed: () {},
    ),
  );
}

@UseCase(name: 'Tappable', type: Tappable, path: '[Actions]')
Widget tappableUseCase(BuildContext context) {
  final enableAnimation = context.knobs.boolean(
    label: 'Scale Animation',
    initialValue: true,
  );
  final enableFocusBorder = context.knobs.boolean(
    label: 'Focus Border',
    initialValue: true,
  );
  final tooltip = context.knobs.string(
    label: 'Tooltip',
    initialValue: 'Tappable surface',
  );

  return Center(
    child: Tappable(
      enableAnimation: enableAnimation,
      enableFocusBorder: enableFocusBorder,
      tooltip: tooltip.isNotEmpty ? tooltip : null,
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.d24,
          vertical: Spacing.d16,
        ),
        decoration: ShapeDecoration(
          color: context.isDark
              ? context.fluffyTheme.colors.neutral6
              : context.fluffyTheme.colors.neutral2,
          shape: const RoundedSuperellipseBorder(
            borderRadius: Spacing.r16,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.touch_app_rounded,
              size: Spacing.d32,
              color: context.fluffyTheme.colors.primary,
            ),
            Spacing.v8,
            Text(
              'Interactive Tappable Card',
              style: context.fluffyTheme.typography.base1,
            ),
            Spacing.v4,
            Text(
              'Supports hover scaling, focus outlines & tooltips',
              style: context.fluffyTheme.typography.caption1.copyWith(
                color: context.fluffyTheme.colors.neutral4,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
