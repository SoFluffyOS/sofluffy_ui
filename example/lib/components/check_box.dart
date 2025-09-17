import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'CheckBox', type: CheckBox)
Widget checkBox(BuildContext context) {
  return CheckBox(
    value: true,
    onChanged: (bool value) {},
  );
}

@UseCase(name: 'CheckBoxListTile', type: CheckBox)
Widget checkBoxListTile(BuildContext context) {
  final style = context.knobs.object.segmented(
    label: 'Style',
    options: CheckBoxListTileStyle.values,
    initialOption: CheckBoxListTileStyle.standard,
    labelBuilder: (value) => value.name,
  );
  final alignment = context.knobs.object.segmented(
    label: 'Alignment',
    options: CheckBoxAlignment.values,
    initialOption: CheckBoxAlignment.left,
    labelBuilder: (value) => value.name,
  );
  final title = context.knobs.string(label: 'Title', initialValue: 'Title');
  final subtitle = switch (style) {
    CheckBoxListTileStyle.standard => context.knobs.string(
      label: 'Subtitle',
      initialValue: '',
    ),
    _ => null,
  };
  return CheckBoxListTile(
    style: style,
    alignment: alignment,
    value: true,
    title: title,
    subtitle: subtitle,
    onChanged: (bool value) {},
  );
}
