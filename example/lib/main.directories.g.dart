// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example/components/button.dart' as _example_components_button;
import 'package:example/components/check_box.dart'
    as _example_components_check_box;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'base_components',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'Button',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Button',
            builder: _example_components_button.button,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'CheckBox',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'CheckBox',
            builder: _example_components_check_box.checkBox,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'CheckBoxListTile',
            builder: _example_components_check_box.checkBoxListTile,
          ),
        ],
      ),
    ],
  ),
];
