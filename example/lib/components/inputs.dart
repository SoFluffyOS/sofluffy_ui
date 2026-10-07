import 'package:flutter/material.dart' show Icon, Icons;
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

class _InteractiveValue<T> extends StatefulWidget {
  final T initial;
  final Widget Function(
    BuildContext context,
    T value,
    ValueChanged<T> onChanged,
  )
  builder;

  const _InteractiveValue({
    super.key,
    required this.initial,
    required this.builder,
  });

  @override
  State<_InteractiveValue<T>> createState() => _InteractiveValueState<T>();
}

class _InteractiveValueState<T> extends State<_InteractiveValue<T>> {
  late T _value = widget.initial;

  @override
  void didUpdateWidget(covariant _InteractiveValue<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial) {
      _value = widget.initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _value,
      (newVal) => setState(() => _value = newVal),
    );
  }
}

@UseCase(name: 'InputText', type: InputText, path: '[Inputs]')
Widget inputTextUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Email Address',
  );
  final hint = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'you@example.com',
  );
  final error = context.knobs.string(label: 'Error Text', initialValue: '');
  final isPassword = context.knobs.boolean(
    label: 'Is Password',
    initialValue: false,
  );
  final readOnly = context.knobs.boolean(
    label: 'Read Only',
    initialValue: false,
  );
  final showPrefix = context.knobs.boolean(
    label: 'Prefix Icon',
    initialValue: true,
  );
  final maxLines = context.knobs.int.slider(
    label: 'Max Lines',
    initialValue: 1,
    min: 1,
    max: 5,
  );

  return Center(
    child: SizedBox(
      width: Spacing.d320,
      child: InputText(
        label: label.isNotEmpty ? label : null,
        hintText: hint.isNotEmpty ? hint : null,
        errorText: error.isNotEmpty ? error : null,
        isPasswordField: isPassword,
        readOnly: readOnly,
        maxLines: maxLines,
        prefix: showPrefix
            ? Icon(
                isPassword
                    ? Icons.lock_outline_rounded
                    : Icons.mail_outline_rounded,
                size: Spacing.d18,
                color: context.fluffyTheme.colors.neutral4,
              )
            : null,
      ),
    ),
  );
}

@UseCase(name: 'FluffySlider', type: FluffySlider, path: '[Inputs]')
Widget fluffySliderUseCase(BuildContext context) {
  final min = context.knobs.double.slider(
    label: 'Min',
    initialValue: 0.0,
    min: 0.0,
    max: 50.0,
  );
  final max = context.knobs.double.slider(
    label: 'Max',
    initialValue: 100.0,
    min: 50.0,
    max: 200.0,
  );
  final divisions = context.knobs.int.slider(
    label: 'Divisions (0 for continuous)',
    initialValue: 10,
    min: 0,
    max: 20,
  );
  final initialVal = context.knobs.double.slider(
    label: 'Current Value',
    initialValue: 50.0,
    min: 0.0,
    max: 100.0,
  );

  return Center(
    child: SizedBox(
      width: Spacing.d280,
      child: _InteractiveValue<double>(
        initial: initialVal.clamp(min, max),
        builder: (context, val, onChanged) {
          final clamped = val.clamp(min, max);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FluffySlider(
                value: clamped,
                min: min,
                max: max,
                divisions: divisions > 0 ? divisions : null,
                onChanged: onChanged,
              ),
              Spacing.v8,
              Text(
                'Value: ${clamped.toStringAsFixed(1)}',
                style: context.fluffyTheme.typography.caption1,
              ),
            ],
          );
        },
      ),
    ),
  );
}

@UseCase(name: 'SwitchToggle', type: SwitchToggle, path: '[Inputs]')
Widget switchToggleUseCase(BuildContext context) {
  final initialValue = context.knobs.boolean(
    label: 'Initial Value',
    initialValue: true,
  );

  return Center(
    child: _InteractiveValue<bool>(
      initial: initialValue,
      builder: (context, isToggled, onChanged) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchToggle(
              value: isToggled,
              onChanged: onChanged,
            ),
            Spacing.h12,
            Text(
              isToggled ? 'Switch: ON' : 'Switch: OFF',
              style: context.fluffyTheme.typography.base1,
            ),
          ],
        );
      },
    ),
  );
}

@UseCase(name: 'CheckBox', type: CheckBox, path: '[Inputs]')
Widget checkBoxUseCase(BuildContext context) {
  final initialValue = context.knobs.boolean(
    label: 'Checked',
    initialValue: true,
  );

  return Center(
    child: _InteractiveValue<bool>(
      initial: initialValue,
      builder: (context, checked, onChanged) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckBox(
              value: checked,
              onChanged: onChanged,
            ),
            Spacing.h8,
            Text(
              'Accept Terms & Conditions',
              style: context.fluffyTheme.typography.base1,
            ),
          ],
        );
      },
    ),
  );
}

@UseCase(name: 'CheckBoxListTile', type: CheckBoxListTile, path: '[Inputs]')
Widget checkBoxListTileUseCase(BuildContext context) {
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
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Notification Alerts',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Receive push notifications for background jobs',
  );

  return Center(
    child: SizedBox(
      width: Spacing.d360,
      child: _InteractiveValue<bool>(
        initial: true,
        builder: (context, checked, onChanged) {
          return CheckBoxListTile(
            style: style,
            alignment: alignment,
            value: checked,
            title: title,
            subtitle:
                style == CheckBoxListTileStyle.standard && subtitle.isNotEmpty
                ? subtitle
                : null,
            onChanged: onChanged,
          );
        },
      ),
    ),
  );
}

@UseCase(name: 'RadioIcon', type: RadioIcon, path: '[Inputs]')
Widget radioIconUseCase(BuildContext context) {
  return Center(
    child: _InteractiveValue<int>(
      initial: 1,
      builder: (context, selected, onChanged) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final i in [1, 2, 3])
              Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.d4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioIcon<int>(
                      value: i,
                      groupValue: selected,
                      onChanged: onChanged,
                    ),
                    Spacing.h8,
                    Text(
                      'Radio Option $i',
                      style: context.fluffyTheme.typography.base1,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    ),
  );
}

@UseCase(name: 'RadioIconListTile', type: RadioIconListTile, path: '[Inputs]')
Widget radioIconListTileUseCase(BuildContext context) {
  final style = context.knobs.object.segmented(
    label: 'Style',
    options: RadioIconListTileStyle.values,
    initialOption: RadioIconListTileStyle.standard,
    labelBuilder: (value) => value.name,
  );
  final alignment = context.knobs.object.segmented(
    label: 'Alignment',
    options: RadioIconAlignment.values,
    initialOption: RadioIconAlignment.left,
    labelBuilder: (value) => value.name,
  );

  return Center(
    child: SizedBox(
      width: Spacing.d360,
      child: _InteractiveValue<String>(
        initial: 'high',
        builder: (context, selected, onChanged) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioIconListTile<String>(
                style: style,
                alignment: alignment,
                value: 'high',
                groupValue: selected,
                title: 'High Quality (1080p)',
                subtitle: style == RadioIconListTileStyle.standard
                    ? 'Recommended for broadband'
                    : null,
                onChanged: onChanged,
              ),
              Spacing.v8,
              RadioIconListTile<String>(
                style: style,
                alignment: alignment,
                value: 'medium',
                groupValue: selected,
                title: 'Medium Quality (720p)',
                subtitle: style == RadioIconListTileStyle.standard
                    ? 'Balances data and clarity'
                    : null,
                onChanged: onChanged,
              ),
            ],
          );
        },
      ),
    ),
  );
}

@UseCase(
  name: 'MultiSelectDropdown',
  type: MultiSelectDropdown,
  path: '[Inputs]',
)
Widget multiSelectDropdownUseCase(BuildContext context) {
  const items = [
    MultiSelectDropdownItem(value: 'flac', label: 'FLAC Audio'),
    MultiSelectDropdownItem(value: 'mp3', label: 'MP3 Audio'),
    MultiSelectDropdownItem(value: 'wav', label: 'WAV Audio'),
    MultiSelectDropdownItem(value: 'aac', label: 'AAC Audio'),
    MultiSelectDropdownItem(value: 'ogg', label: 'OGG Vorbis'),
  ];

  return Center(
    child: SizedBox(
      width: Spacing.d280,
      child: _InteractiveValue<Set<String>>(
        initial: const {'flac', 'mp3'},
        builder: (context, selected, onChanged) {
          return MultiSelectDropdown<String>(
            label: 'Audio Formats',
            items: items,
            selectedValues: selected,
            onChanged: onChanged,
          );
        },
      ),
    ),
  );
}

@UseCase(name: 'DatePicker', type: DatePicker, path: '[Inputs]')
Widget datePickerUseCase(BuildContext context) {
  return Center(
    child: _InteractiveValue<DateTime?>(
      initial: null,
      builder: (context, picked, onChanged) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              variant: ButtonVariant.secondary,
              label: 'Open Date Picker',
              onPressed: () async {
                final date = await DatePicker.show(
                  context,
                  initialDate: picked ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  onChanged(date);
                }
              },
            ),
            if (picked != null) ...[
              Spacing.v8,
              Text(
                'Selected: ${picked.toLocal().toString().split(' ')[0]}',
                style: context.fluffyTheme.typography.caption1,
              ),
            ],
          ],
        );
      },
    ),
  );
}
