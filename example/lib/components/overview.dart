import 'package:flutter/material.dart' show Icon, Icons;
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

class OverviewCatalog extends StatelessWidget {
  const OverviewCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OverviewContent();
  }
}

class _OverviewContent extends StatefulWidget {
  const _OverviewContent();

  @override
  State<_OverviewContent> createState() => _OverviewContentState();
}

class _OverviewContentState extends State<_OverviewContent> {
  // Interactive state variables
  bool _switchValue = true;
  bool _checkboxValue = true;
  String _radioValue = 'mkv';
  double _sliderValue = 65.0;
  Set<String> _selectedFormats = const {'mp4', 'mkv'};
  DateTime? _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final typography = theme.typography;
    final isDark = context.isDark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: Spacing.d8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SoFluffyLogoWithName(name: 'UI'),
                  Spacing.v16,
                  Text(
                    'Component Showcase',
                    style: typography.headline4.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacing.v4,
                  Text(
                    'Interactive overview of available UI components across platforms.',
                    style: typography.base2.copyWith(
                      color: isDark
                          ? theme.colors.neutral4
                          : theme.colors.neutral5,
                    ),
                  ),
                ],
              ),
              Spacing.v24,

              // Section: Actions
              _buildSection(
                title: 'Actions',
                subtitle: 'Buttons, icon triggers, and interactive surfaces',
                child: Wrap(
                  spacing: Spacing.d12,
                  runSpacing: Spacing.d12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Button(
                      variant: ButtonVariant.primary,
                      label: 'Primary Button',
                      onPressed: () {},
                    ),
                    Button(
                      variant: ButtonVariant.secondary,
                      label: 'Secondary',
                      icon: const Icon(Icons.star_rounded, size: 18),
                      onPressed: () {},
                    ),
                    Button(
                      variant: ButtonVariant.ghost,
                      label: 'Ghost Action',
                      trailingIcon: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                      ),
                      onPressed: () {},
                    ),
                    const Button(
                      variant: ButtonVariant.primary,
                      enable: false,
                      label: 'Disabled',
                    ),
                    RoundButton(
                      icon: Icons.add_rounded,
                      tooltip: 'Add item',
                      onPressed: () {},
                    ),
                    RoundButton(
                      icon: Icons.refresh_rounded,
                      tooltip: 'Refresh',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Spacing.v24,

              // Section: Inputs & Controls
              _buildSection(
                title: 'Inputs & Controls',
                subtitle:
                    'Selection controls, sliders, text input, and pickers',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Text fields & Dropdowns row
                    Wrap(
                      spacing: Spacing.d16,
                      runSpacing: Spacing.d16,
                      children: [
                        SizedBox(
                          width: Spacing.d320,
                          child: const InputText(
                            label: 'Preset Name',
                            hintText: 'e.g. YouTube 4K ProRes',
                          ),
                        ),
                        SizedBox(
                          width: Spacing.d320,
                          child: MultiSelectDropdown<String>(
                            label: 'Containers',
                            items: [
                              for (final f in const [
                                'mp4',
                                'mkv',
                                'webm',
                                'mov',
                              ])
                                MultiSelectDropdownItem(
                                  value: f,
                                  label: f.toUpperCase(),
                                ),
                            ],
                            selectedValues: _selectedFormats,
                            onChanged: (selected) {
                              setState(() => _selectedFormats = selected);
                            },
                          ),
                        ),
                      ],
                    ),
                    Spacing.v24,

                    // Slider row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bitrate: ${_sliderValue.toInt()} Mbps',
                                style: typography.caption1.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacing.v4,
                              FluffySlider(
                                value: _sliderValue,
                                min: 10,
                                max: 100,
                                onChanged: (val) {
                                  setState(() => _sliderValue = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacing.v24,

                    // Toggles & Selection controls
                    Wrap(
                      spacing: Spacing.d24,
                      runSpacing: Spacing.d12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SwitchToggle(
                              value: _switchValue,
                              onChanged: (val) =>
                                  setState(() => _switchValue = val),
                            ),
                            Spacing.h8,
                            Text(
                              _switchValue
                                  ? 'Hardware Acceleration (ON)'
                                  : 'Hardware Acceleration (OFF)',
                              style: typography.base2,
                            ),
                          ],
                        ),
                        _TapLabel(
                          onTap: () => setState(
                            () => _checkboxValue = !_checkboxValue,
                          ),
                          children: [
                            CheckBox(
                              value: _checkboxValue,
                              onChanged: (val) =>
                                  setState(() => _checkboxValue = val),
                            ),
                            Spacing.h8,
                            Text('Preserve subtitles', style: typography.base2),
                          ],
                        ),
                      ],
                    ),
                    Spacing.v16,

                    // Radio tile & Date Picker trigger row
                    Wrap(
                      spacing: Spacing.d16,
                      runSpacing: Spacing.d12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _TapLabel(
                              onTap: () => setState(() => _radioValue = 'mp4'),
                              children: [
                                RadioIcon<String>(
                                  value: 'mp4',
                                  groupValue: _radioValue,
                                  onChanged: (val) =>
                                      setState(() => _radioValue = val),
                                ),
                                Spacing.h4,
                                const Text('MP4'),
                              ],
                            ),
                            Spacing.h16,
                            _TapLabel(
                              onTap: () => setState(() => _radioValue = 'mkv'),
                              children: [
                                RadioIcon<String>(
                                  value: 'mkv',
                                  groupValue: _radioValue,
                                  onChanged: (val) =>
                                      setState(() => _radioValue = val),
                                ),
                                Spacing.h4,
                                const Text('MKV'),
                              ],
                            ),
                          ],
                        ),
                        Button(
                          variant: ButtonVariant.secondary,
                          icon: const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                          ),
                          label: _selectedDate == null
                              ? 'Pick Target Date'
                              : 'Date: ${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                          onPressed: () async {
                            final picked = await DatePicker.show(
                              context,
                              initialDate: _selectedDate,
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacing.v24,

              // Section: Display & Feedback
              _buildSection(
                title: 'Display & Feedback',
                subtitle: 'Badges, cards, tooltips, links, and step indicators',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags & Tooltips
                    Wrap(
                      spacing: Spacing.d8,
                      runSpacing: Spacing.d8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Tag('Pro Feature', color: theme.colors.primary),
                        const Tag('AV1 Codec', color: FluffyColors.success),
                        const Tag('Experimental', color: FluffyColors.warning),
                        Spacing.h8,
                        FluffyTooltip(
                          message: 'Displays high precision audio tracks',
                          child: Tag(
                            'Hover for Tooltip',
                            color: theme.colors.primary,
                          ),
                        ),
                        LinkText(
                          'View Documentation ↗',
                          onTap: () {},
                        ),
                      ],
                    ),
                    Spacing.v16,

                    // Stepper
                    const StepperWidget(
                      stepCount: 4,
                      currentStep: 2,
                    ),
                    Spacing.v16,

                    // Shimmer loading
                    Row(
                      children: [
                        LoadingBox(
                          width: 120,
                          height: Spacing.d32,
                          shimmerBorderRadius: Spacing.d8,
                        ),
                        Spacing.h12,
                        const Expanded(
                          child: LoadingText(null, loadingLength: 6),
                        ),
                      ],
                    ),
                    Spacing.v16,

                    // RoundCard / ListItem preview
                    RoundCard(
                      child: ListItem(
                        leading: const Icon(Icons.movie_filter_rounded),
                        title: 'video_clip_sample.mov',
                        subtitle: '1080p60 • ProRes 422HQ • 2.4 GB',
                        trailing: Button(
                          variant: ButtonVariant.ghost,
                          label: 'Configure',
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.v24,

              // Section: Dialogs & Modals
              _buildSection(
                title: 'Dialogs & Modals',
                subtitle: 'Popups, prompts, and modal workflows',
                child: Wrap(
                  spacing: Spacing.d12,
                  runSpacing: Spacing.d12,
                  children: [
                    Button(
                      variant: ButtonVariant.secondary,
                      label: 'Launch Confirm Dialog',
                      onPressed: () async {
                        await ConfirmDialog.show(
                          context,
                          title: 'Export Queue',
                          message: 'Start converting 14 selected video files?',
                          positiveText: 'Start Queue',
                          negativeText: 'Cancel',
                        );
                      },
                    ),
                    Button(
                      variant: ButtonVariant.secondary,
                      label: 'Launch Input Dialog',
                      onPressed: () async {
                        await InputTextDialog.show(
                          context,
                          title: 'Rename Preset',
                          labelText: 'Preset Name',
                          confirmText: 'Save',
                          cancelText: 'Cancel',
                          initialValue: 'H.265 Master Copy',
                        );
                      },
                    ),
                    Button(
                      variant: ButtonVariant.secondary,
                      label: 'Launch Slider Dialog',
                      onPressed: () async {
                        await InputSliderDialog.show(
                          context,
                          title: 'Adjust CRF Quality',
                          min: 0,
                          max: 51,
                          initialValue: 22,
                          confirmText: 'Apply',
                          cancelText: 'Cancel',
                        );
                      },
                    ),
                    Button(
                      variant: ButtonVariant.secondary,
                      label: 'Launch Radio Options Dialog',
                      onPressed: () async {
                        await RadioOptionsDialog.show<String>(
                          context,
                          title: 'Output Audio Codec',
                          message: 'Choose audio compression stream format.',
                          values: const ['aac', 'opus', 'flac', 'pcm'],
                          initialValue: 'opus',
                          itemLabelBuilder: (val) => val.toUpperCase(),
                          confirmText: 'Select',
                          cancelText: 'Cancel',
                        );
                      },
                    ),
                  ],
                ),
              ),
              Spacing.v32,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final theme = context.fluffyTheme;
    final typography = theme.typography;
    final isDark = context.isDark;

    return RoundCard(
      padding: EdgeInsets.all(Spacing.d20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: typography.headline6.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.v4,
          Text(
            subtitle,
            style: typography.caption1.copyWith(
              color: isDark ? theme.colors.neutral4 : theme.colors.neutral5,
            ),
          ),
          Spacing.v16,
          child,
        ],
      ),
    );
  }
}

@UseCase(
  name: 'All Widgets Overview',
  type: OverviewCatalog,
  path: '[Overview]',
)
Widget overviewCatalogUseCase(BuildContext context) {
  return const OverviewCatalog();
}

/// Makes the whole control + label row tappable.
class _TapLabel extends StatelessWidget {
  final VoidCallback onTap;
  final List<Widget> children;

  const _TapLabel({required this.onTap, required this.children});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
