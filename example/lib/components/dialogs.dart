import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

class _InteractiveDialogState<T> extends StatefulWidget {
  final T initial;
  final Widget Function(
    BuildContext context,
    T value,
    ValueChanged<T> onUpdated,
  )
  builder;

  const _InteractiveDialogState({
    required this.initial,
    required this.builder,
  });

  @override
  State<_InteractiveDialogState<T>> createState() =>
      _InteractiveDialogStateState<T>();
}

class _InteractiveDialogStateState<T>
    extends State<_InteractiveDialogState<T>> {
  late T _value = widget.initial;

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _value,
      (newVal) => setState(() => _value = newVal),
    );
  }
}

@UseCase(name: 'DialogCard', type: DialogCard, path: '[Dialogs]')
Widget dialogCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Discard Unsaved Changes?',
  );
  final message = context.knobs.string(
    label: 'Content',
    initialValue:
        'You have unsaved conversion preset modifications that will be lost.',
  );

  return Center(
    child: SizedBox(
      width: Spacing.d360,
      child: DialogCard(
        title: Text(title, style: context.fluffyTheme.typography.headline6),
        content: Text(message, style: context.fluffyTheme.typography.base2),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button(
                variant: ButtonVariant.ghost,
                label: 'Cancel',
                mainAxisSize: MainAxisSize.min,
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.d16,
                  vertical: Spacing.d8,
                ),
                onPressed: () {},
              ),
              Spacing.h8,
              Button(
                variant: ButtonVariant.primary,
                label: 'Discard',
                mainAxisSize: MainAxisSize.min,
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.d16,
                  vertical: Spacing.d8,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

@UseCase(name: 'ConfirmDialog', type: ConfirmDialog, path: '[Dialogs]')
Widget confirmDialogUseCase(BuildContext context) {
  return Center(
    child: _InteractiveDialogState<String>(
      initial: 'None',
      builder: (context, result, onUpdated) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              variant: ButtonVariant.primary,
              label: 'Launch Confirm Dialog',
              onPressed: () async {
                final action = await ConfirmDialog.show(
                  context,
                  title: 'Delete Preset',
                  message:
                      'Are you sure you want to delete "Ultra Fast 1080p"?',
                  positiveText: 'Delete',
                  negativeText: 'Cancel',
                );
                onUpdated(action.name);
              },
            ),
            Spacing.v8,
            Text(
              'Dialog Result: $result',
              style: context.fluffyTheme.typography.caption1,
            ),
          ],
        );
      },
    ),
  );
}

@UseCase(name: 'ContentDialog', type: ContentDialog, path: '[Dialogs]')
Widget contentDialogUseCase(BuildContext context) {
  return Center(
    child: Button(
      variant: ButtonVariant.secondary,
      label: 'Launch Content Dialog',
      onPressed: () {
        ContentDialog.show(
          context,
          title: 'Terms of Service',
          content:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
          positiveText: 'I Agree',
          negativeText: 'Decline',
        );
      },
    ),
  );
}

@UseCase(name: 'InputTextDialog', type: InputTextDialog, path: '[Dialogs]')
Widget inputTextDialogUseCase(BuildContext context) {
  return Center(
    child: _InteractiveDialogState<String>(
      initial: '',
      builder: (context, entered, onUpdated) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              variant: ButtonVariant.secondary,
              label: 'Launch Input Text Dialog',
              onPressed: () async {
                final val = await InputTextDialog.show(
                  context,
                  title: 'Rename Preset',
                  labelText: 'Preset Name',
                  hintText: 'e.g. YouTube High Quality',
                  confirmText: 'Save',
                  cancelText: 'Cancel',
                  initialValue: 'My Custom Preset',
                );
                if (val != null) {
                  onUpdated(val);
                }
              },
            ),
            if (entered.isNotEmpty) ...[
              Spacing.v8,
              Text(
                'Entered Text: $entered',
                style: context.fluffyTheme.typography.caption1,
              ),
            ],
          ],
        );
      },
    ),
  );
}

@UseCase(name: 'InputSliderDialog', type: InputSliderDialog, path: '[Dialogs]')
Widget inputSliderDialogUseCase(BuildContext context) {
  return Center(
    child: _InteractiveDialogState<double?>(
      initial: null,
      builder: (context, selectedValue, onUpdated) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              variant: ButtonVariant.secondary,
              label: 'Launch Slider Dialog',
              onPressed: () async {
                final val = await InputSliderDialog.show(
                  context,
                  title: 'Audio Compression Rate',
                  min: 64,
                  max: 320,
                  initialValue: 192,
                  divisions: 8,
                  labelBuilder: (v) => '${v.toInt()} kbps',
                  confirmText: 'Apply',
                  cancelText: 'Cancel',
                );
                if (val != null) {
                  onUpdated(val);
                }
              },
            ),
            if (selectedValue != null) ...[
              Spacing.v8,
              Text(
                'Selected: ${selectedValue.toInt()} kbps',
                style: context.fluffyTheme.typography.caption1,
              ),
            ],
          ],
        );
      },
    ),
  );
}

@UseCase(
  name: 'RadioOptionsDialog',
  type: RadioOptionsDialog,
  path: '[Dialogs]',
)
Widget radioOptionsDialogUseCase(BuildContext context) {
  return Center(
    child: _InteractiveDialogState<String>(
      initial: 'mkv',
      builder: (context, selected, onUpdated) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              variant: ButtonVariant.secondary,
              label: 'Select Video Container',
              onPressed: () async {
                final val = await RadioOptionsDialog.show<String>(
                  context,
                  title: 'Select Output Container',
                  message:
                      'Choose default container for multiplexing video streams.',
                  values: ['mp4', 'mkv', 'webm', 'avi'],
                  initialValue: selected,
                  itemLabelBuilder: (item) => item.toUpperCase(),
                  confirmText: 'Confirm',
                  cancelText: 'Cancel',
                );
                if (val != null) {
                  onUpdated(val);
                }
              },
            ),
            Spacing.v8,
            Text(
              'Current Container: ${selected.toUpperCase()}',
              style: context.fluffyTheme.typography.caption1,
            ),
          ],
        );
      },
    ),
  );
}
