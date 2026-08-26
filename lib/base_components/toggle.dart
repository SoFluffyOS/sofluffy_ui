import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class Toggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const Toggle({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  late bool _currentValue = widget.initialValue;

  void _onChanged(bool value) {
    setState(() {
      _currentValue = value;
    });
    widget.onChanged(value);
  }

  @override
  void didUpdateWidget(covariant Toggle oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _currentValue = widget.initialValue;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onChanged(!_currentValue),
        child: AnimatedContainer(
          width: Spacing.d48,
          height: Spacing.d24,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: ShapeDecoration(
            color: _getBackgroundColor(context),
            shape: const RoundedSuperellipseBorder(
              borderRadius: Spacing.r12,
            ),
          ),
          alignment: _currentValue
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: Spacing.d2),
          child: Tappable(
            enableAnimation: true,
            enableFocusBorder: false,
            onTap: () => _onChanged(!_currentValue),
            child: AnimatedContainer(
              width: Spacing.d20,
              height: Spacing.d20,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: ShapeDecoration(
                shape: const RoundedSuperellipseBorder(
                  borderRadius: Spacing.r10,
                ),
                color: _getKnobColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    if (_currentValue) {
      return theme.colors.primary;
    }

    return isDark ? theme.colors.neutral5 : theme.colors.neutral3;
  }

  Color _getKnobColor(BuildContext context) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    if (isDark && !_currentValue) {
      return theme.colors.neutral7;
    }

    return theme.colors.neutral1;
  }
}
