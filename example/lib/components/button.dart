import 'package:flutter/material.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Button', type: Button)
Widget button(BuildContext context) {
  final variant = context.knobs.object.segmented(
    label: 'Variant',
    options: ButtonVariant.values,
    initialOption: ButtonVariant.primary,
    labelBuilder: (value) => value.name,
  );
  return Button(
    variant: variant,
    enable: context.knobs.boolean(label: 'Enable', initialValue: true),
    label: context.knobs.string(label: 'Label', initialValue: 'Primary Button'),
    tooltip: context.knobs.string(
      label: 'Tooltip',
      initialValue: 'Primary Button',
    ),
    radius: context.knobs.double.slider(
      label: 'Border Radius',
      initialValue: 12.0,
      max: 100.0,
    ),
    icon: context.knobs.boolean(label: 'Icon', initialValue: false)
        ? Icon(
            Icons.qr_code,
            size: Spacing.d24,
            color: switch (variant) {
              ButtonVariant.primary => Theme.of(context).colorScheme.onPrimary,
              ButtonVariant.secondary => Theme.of(
                context,
              ).colorScheme.onSecondary,
              ButtonVariant.ghost => Theme.of(context).colorScheme.onSurface,
            },
          )
        : null,
    onPressed: () {},
  );
}
