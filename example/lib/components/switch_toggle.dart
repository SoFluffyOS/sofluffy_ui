import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'SwitchToggle', type: SwitchToggle)
Widget switchToggle(BuildContext context) {
  return SwitchToggle(
    value: true,
    onChanged: (bool value) {},
  );
}