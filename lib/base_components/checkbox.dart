import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CheckBox({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  late bool _currentValue = widget.initialValue;
  bool _isHovering = false;

  void _onChanged(bool value) {
    setState(() {
      _currentValue = value;
    });
    widget.onChanged(value);
  }

  @override
  void didUpdateWidget(covariant CheckBox oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _currentValue = widget.initialValue;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Tappable(
      enableAnimation: true,
      enableHover: true,
      onStateChanged: (state) {
        setState(() {
          _isHovering = state == TappableState.hover;
        });
      },
      onTap: () => _onChanged(!_currentValue),
      child: CheckBoxIcon(
        state: _currentValue
            ? CheckBoxIconState.checked
            : _isHovering
                ? CheckBoxIconState.hover
                : CheckBoxIconState.unchecked,
      ),
    );
  }
}

enum CheckBoxIconState {
  checked,
  unchecked,
  hover,
}

class CheckBoxIcon extends StatelessWidget {
  final CheckBoxIconState state;

  const CheckBoxIcon({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: Spacing.d24,
      height: Spacing.d24,
      curve: Curves.easeOut,
      duration: Durations.medium1,
      decoration: ShapeDecoration(
        color: _getBackgroundColor(context, state),
        shape: SmoothRectangleBorder(
          borderRadius: const SmoothBorderRadius.all(
            SmoothRadius(
              cornerRadius: 6.0,
              cornerSmoothing: 1.0,
            ),
          ),
          side: BorderSide(
            color: _getBorderColor(context, state),
            width: 2.0,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderAlign: BorderAlign.inside,
        ),
      ),
      alignment: Alignment.center,
      child: state != CheckBoxIconState.checked
          ? null
          : ImageView(
              Assets.solidCheckValidationTick02,
              width: Spacing.d18,
              height: Spacing.d18,
              color: ThemeConfigs().theme.colors.neutral1,
            ),
    );
  }

  Color _getBackgroundColor(BuildContext context, CheckBoxIconState state) {
    final isDark = context.theme.brightness == Brightness.dark;
    return switch (state) {
      CheckBoxIconState.checked => ThemeConfigs().theme.colors.primary,
      CheckBoxIconState.unchecked => isDark
          ? ThemeConfigs().theme.colors.neutral7
          : ThemeConfigs().theme.colors.neutral1,
      CheckBoxIconState.hover => isDark
          ? ThemeConfigs().theme.colors.neutral6
          : ThemeConfigs().theme.colors.neutral3,
    };
  }

  Color _getBorderColor(BuildContext context, CheckBoxIconState state) {
    final isDark = context.theme.brightness == Brightness.dark;
    return switch (state) {
      CheckBoxIconState.checked => ThemeConfigs().theme.colors.primary,
      _ => isDark
          ? ThemeConfigs().theme.colors.neutral6
          : ThemeConfigs().theme.colors.neutral3,
    };
  }
}
