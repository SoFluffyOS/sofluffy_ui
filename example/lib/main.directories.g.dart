// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example/components/actions.dart' as _example_components_actions;
import 'package:example/components/brand.dart' as _example_components_brand;
import 'package:example/components/dialogs.dart' as _example_components_dialogs;
import 'package:example/components/display.dart' as _example_components_display;
import 'package:example/components/inputs.dart' as _example_components_inputs;
import 'package:example/components/overview.dart'
    as _example_components_overview;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Actions',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'Button',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Button',
            builder: _example_components_actions.buttonUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RoundButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'RoundButton',
            builder: _example_components_actions.roundButtonUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'Tappable',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Tappable',
            builder: _example_components_actions.tappableUseCase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Brand',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'SoFluffyLogo',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'SoFluffyLogo',
            builder: _example_components_brand.logoUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SoFluffyLogoWithName',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'SoFluffyLogoWithName',
            builder: _example_components_brand.logoWithNameUseCase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Dialogs',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'ConfirmDialog',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'ConfirmDialog',
            builder: _example_components_dialogs.confirmDialogUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'ContentDialog',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'ContentDialog',
            builder: _example_components_dialogs.contentDialogUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'DialogCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'DialogCard',
            builder: _example_components_dialogs.dialogCardUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'InputSliderDialog',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'InputSliderDialog',
            builder: _example_components_dialogs.inputSliderDialogUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'InputTextDialog',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'InputTextDialog',
            builder: _example_components_dialogs.inputTextDialogUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RadioOptionsDialog',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'RadioOptionsDialog',
            builder: _example_components_dialogs.radioOptionsDialogUseCase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Display',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'FluffyTooltip',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'FluffyTooltip',
            builder: _example_components_display.fluffyTooltipUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'LinkText',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'LinkText',
            builder: _example_components_display.linkTextUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'ListItem',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'ListItem',
            builder: _example_components_display.listItemUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'LoadingBox',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'LoadingBox',
            builder: _example_components_display.loadingBoxUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RoundCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'RoundCard',
            builder: _example_components_display.roundCardUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'StepperWidget',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'StepperWidget',
            builder: _example_components_display.stepperWidgetUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'Tag',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Tag',
            builder: _example_components_display.tagUseCase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Inputs',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'CheckBox',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'CheckBox',
            builder: _example_components_inputs.checkBoxUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'CheckBoxListTile',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'CheckBoxListTile',
            builder: _example_components_inputs.checkBoxListTileUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'DatePicker',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'DatePicker',
            builder: _example_components_inputs.datePickerUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'FluffySlider',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'FluffySlider',
            builder: _example_components_inputs.fluffySliderUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'InputText',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'InputText',
            builder: _example_components_inputs.inputTextUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'MultiSelectDropdown',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'MultiSelectDropdown',
            builder: _example_components_inputs.multiSelectDropdownUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RadioIcon',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'RadioIcon',
            builder: _example_components_inputs.radioIconUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RadioIconListTile',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'RadioIconListTile',
            builder: _example_components_inputs.radioIconListTileUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SwitchToggle',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'SwitchToggle',
            builder: _example_components_inputs.switchToggleUseCase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Overview',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'OverviewCatalog',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'All Widgets Overview',
            builder: _example_components_overview.overviewCatalogUseCase,
          ),
        ],
      ),
    ],
  ),
];
