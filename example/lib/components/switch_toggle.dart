import 'package:flutter/material.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'SwitchToggle', type: SwitchToggle)
Widget switchToggle(BuildContext context) {
  return SwitchToggle(
    value: true,
    onChanged: (bool value) {},
  );
}
