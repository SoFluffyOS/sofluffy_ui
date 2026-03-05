import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

part 'check_box_list_tile.dart';

class CheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  late bool _currentValue = widget.value;
  bool _isHovering = false;

  void _onChanged(bool value) {
    setState(() {
      _currentValue = value;
    });
    widget.onChanged(value);
  }

  @override
  void didUpdateWidget(covariant CheckBox oldWidget) {
    if (oldWidget.value != widget.value) {
      _currentValue = widget.value;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = switch (Theme.of(context).platform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };
    return Tappable(
      enableAnimation: true,
      enableHover: true,
      onStateChanged: (state) {
        setState(() {
          _isHovering = state.isHovered;
        });
      },
      onTap: () => _onChanged(!_currentValue),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? Spacing.d4 : Spacing.d8),
        child: CheckBoxIcon(
          state: _currentValue
              ? CheckBoxIconState.checked
              : _isHovering
              ? CheckBoxIconState.hover
              : CheckBoxIconState.unchecked,
        ),
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
    final isDesktop = switch (Theme.of(context).platform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };
    return AnimatedContainer(
      width: isDesktop ? Spacing.d16 : Spacing.d24,
      height: isDesktop ? Spacing.d16 : Spacing.d24,
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
              DesignSystemAssets.icons.tick02Solid,
              width: isDesktop ? 12.0 : Spacing.d18,
              height: isDesktop ? 12.0 : Spacing.d18,
              color: context.themeConfigs.colors.neutral1,
              assetPackage: kDesignSystemPackageName,
            ),
    );
  }

  Color _getBackgroundColor(BuildContext context, CheckBoxIconState state) {
    final isDark = context.theme.brightness == Brightness.dark;
    final theme = context.themeConfigs;
    return switch (state) {
      CheckBoxIconState.checked => theme.colors.primary,
      CheckBoxIconState.unchecked =>
        isDark ? theme.colors.neutral7 : theme.colors.neutral1,
      CheckBoxIconState.hover =>
        isDark ? theme.colors.neutral6 : theme.colors.neutral3,
    };
  }

  Color _getBorderColor(BuildContext context, CheckBoxIconState state) {
    final isDark = context.theme.brightness == Brightness.dark;
    final theme = context.themeConfigs;
    return switch (state) {
      CheckBoxIconState.checked => theme.colors.primary,
      _ => isDark ? theme.colors.neutral6 : theme.colors.neutral3,
    };
  }
}
