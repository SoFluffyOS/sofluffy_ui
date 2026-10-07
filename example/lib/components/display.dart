import 'package:flutter/material.dart' show Icon, Icons;
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'FluffyTooltip', type: FluffyTooltip, path: '[Display]')
Widget fluffyTooltipUseCase(BuildContext context) {
  final message = context.knobs.string(
    label: 'Tooltip Message',
    initialValue: 'This is a styled fluffy tooltip',
  );

  return Center(
    child: FluffyTooltip(
      message: message,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.d20,
          vertical: Spacing.d12,
        ),
        decoration: ShapeDecoration(
          color: context.isDark
              ? context.fluffyTheme.colors.neutral6
              : context.fluffyTheme.colors.neutral2,
          shape: const RoundedSuperellipseBorder(
            borderRadius: Spacing.r12,
          ),
        ),
        child: Text(
          'Hover over me',
          style: context.fluffyTheme.typography.base1,
        ),
      ),
    ),
  );
}

@UseCase(name: 'Tag', type: Tag, path: '[Display]')
Widget tagUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'Tag Text', initialValue: 'Feature');
  final colorOption = context.knobs.object.segmented(
    label: 'Color Palette',
    options: ['Primary', 'Success', 'Warning', 'Neutral'],
    initialOption: 'Primary',
  );

  final color = switch (colorOption) {
    'Success' => FluffyColors.success,
    'Warning' => FluffyColors.warning,
    'Neutral' =>
      context.isDark
          ? context.fluffyTheme.colors.neutral2
          : context.fluffyTheme.colors.neutral6,
    _ => context.fluffyTheme.colors.primary,
  };

  return Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tag(text, color: color),
        Spacing.h8,
        Tag('PRO', color: context.fluffyTheme.colors.primary),
        Spacing.h8,
        const Tag('BETA', color: FluffyColors.warning),
      ],
    ),
  );
}

@UseCase(name: 'RoundCard', type: RoundCard, path: '[Display]')
Widget roundCardUseCase(BuildContext context) {
  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 16.0,
    min: 4.0,
    max: 32.0,
  );
  final showBorder = context.knobs.boolean(
    label: 'Show Border',
    initialValue: true,
  );

  return Center(
    child: SizedBox(
      width: Spacing.d320,
      child: RoundCard(
        borderRadius: borderRadius,
        borderColor: showBorder
            ? (context.isDark
                  ? context.fluffyTheme.colors.neutral5
                  : context.fluffyTheme.colors.neutral3)
            : null,
        padding: EdgeInsets.all(Spacing.d20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RoundCard Surface',
              style: context.fluffyTheme.typography.headline6,
            ),
            Spacing.v8,
            Text(
              'A standard card container supporting superellipse rounded corners, custom borders, and shadows.',
              style: context.fluffyTheme.typography.base2.copyWith(
                color: context.fluffyTheme.colors.neutral4,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

@UseCase(name: 'ListItem', type: ListItem, path: '[Display]')
Widget listItemUseCase(BuildContext context) {
  final style = context.knobs.object.segmented(
    label: 'Style',
    options: ListItemStyle.values,
    initialOption: ListItemStyle.standard,
    labelBuilder: (value) => value.name,
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Audio Encoding Options',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Configure sample rate, bitrate and channel mapping',
  );

  return Center(
    child: SizedBox(
      width: Spacing.d360,
      child: RoundCard(
        padding: EdgeInsets.symmetric(vertical: Spacing.d8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListItem(
              style: style,
              title: title,
              subtitle: style == ListItemStyle.standard ? subtitle : null,
              leading: Icon(
                Icons.graphic_eq_rounded,
                size: Spacing.d20,
                color: context.fluffyTheme.colors.primary,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                size: Spacing.d20,
                color: context.fluffyTheme.colors.neutral4,
              ),
              onTap: () {},
            ),
            ListItem(
              style: style,
              title: 'Output Directory',
              subtitle: style == ListItemStyle.standard
                  ? '/storage/emulated/0/Music'
                  : null,
              leading: Icon(
                Icons.folder_open_rounded,
                size: Spacing.d20,
                color: context.fluffyTheme.colors.primary,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                size: Spacing.d20,
                color: context.fluffyTheme.colors.neutral4,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  );
}

@UseCase(name: 'LinkText', type: LinkText, path: '[Display]')
Widget linkTextUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Link Text',
    initialValue: 'Learn more about SoFluffy UI',
  );
  final showUnderline = context.knobs.boolean(
    label: 'Underline When Normal',
    initialValue: true,
  );

  return Center(
    child: LinkText(
      text,
      showUnderlineWhenNormal: showUnderline,
      onTap: () {},
    ),
  );
}

@UseCase(name: 'StepperWidget', type: StepperWidget, path: '[Display]')
Widget stepperWidgetUseCase(BuildContext context) {
  final stepCount = context.knobs.int.slider(
    label: 'Step Count',
    initialValue: 4,
    min: 2,
    max: 8,
  );
  final currentStep = context.knobs.int.slider(
    label: 'Current Step',
    initialValue: 1,
    min: 0,
    max: 7,
  );

  return Center(
    child: StepperWidget(
      stepCount: stepCount,
      currentStep: currentStep,
    ),
  );
}

@UseCase(name: 'LoadingBox', type: LoadingBox, path: '[Display]')
Widget loadingBoxUseCase(BuildContext context) {
  final width = context.knobs.double.slider(
    label: 'Width',
    initialValue: 200.0,
    min: 50.0,
    max: 300.0,
  );
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 40.0,
    min: 10.0,
    max: 100.0,
  );
  final radius = context.knobs.double.slider(
    label: 'Radius',
    initialValue: 12.0,
    min: 4.0,
    max: 24.0,
  );

  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadingBox(
          width: width,
          height: height,
          shimmerBorderRadius: radius,
        ),
        Spacing.v12,
        const LoadingText(null, loadingLength: 8),
      ],
    ),
  );
}
