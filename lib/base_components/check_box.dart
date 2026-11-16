import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

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
        padding: EdgeInsets.all(Spacing.d4),
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

  /// Some of what it stands for is checked: a dash.
  mixed,
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
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    final markColor = isDark ? theme.colors.neutral7 : theme.colors.neutral1;
    return AnimatedContainer(
      width: Spacing.d16,
      height: Spacing.d16,
      curve: Curves.easeOut,
      duration: FluffyDurations.normal,
      decoration: ShapeDecoration(
        color: _getBackgroundColor(context, state),
        shape: RoundedSuperellipseBorder(
          borderRadius: Spacing.r6,
          side: BorderSide(
            color: _getBorderColor(context, state),
            width: Spacing.d2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: switch (state) {
        CheckBoxIconState.checked => ImageView(
          FluffyAssets.icons.tick02Solid,
          width: Spacing.d12,
          height: Spacing.d12,
          color: markColor,
          assetPackage: kSofluffyUiPackageName,
        ),
        CheckBoxIconState.mixed => Container(
          width: Spacing.d8,
          height: Spacing.d2,
          decoration: BoxDecoration(
            color: markColor,
            borderRadius: Spacing.r4,
          ),
        ),
        CheckBoxIconState.unchecked || CheckBoxIconState.hover => null,
      },
    );
  }

  Color _getBackgroundColor(BuildContext context, CheckBoxIconState state) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    return switch (state) {
      CheckBoxIconState.checked ||
      CheckBoxIconState.mixed => theme.colors.primary,
      CheckBoxIconState.unchecked =>
        isDark ? theme.colors.neutral7 : theme.colors.neutral1,
      CheckBoxIconState.hover =>
        isDark ? theme.colors.neutral6 : theme.colors.neutral3,
    };
  }

  Color _getBorderColor(BuildContext context, CheckBoxIconState state) {
    final theme = context.fluffyTheme;
    return switch (state) {
      CheckBoxIconState.checked ||
      CheckBoxIconState.mixed => theme.colors.primary,
      _ => theme.colors.neutral4,
    };
  }
}
