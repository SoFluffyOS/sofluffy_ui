import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

part 'radio_list_tile.dart';

class RadioIcon<T> extends StatefulWidget {
  final T? groupValue;
  final T value;
  final ValueChanged<T> onChanged;

  const RadioIcon({
    super.key,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  @override
  State<RadioIcon<T>> createState() => _RadioIconState<T>();
}

class _RadioIconState<T> extends State<RadioIcon<T>> {
  bool get _isSelected => widget.value == widget.groupValue;
  bool _isHovering = false;

  @override
  void didUpdateWidget(covariant RadioIcon<T> oldWidget) {
    if (oldWidget.value != widget.value ||
        oldWidget.groupValue != widget.groupValue) {
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
      onTap: () {
        if (_isSelected) {
          return;
        }
        widget.onChanged(widget.value);
      },
      child: Padding(
        padding: EdgeInsets.all(Spacing.d8),
        child: _RadioIconView(
          state: _isSelected
              ? RadioIconState.checked
              : _isHovering
              ? RadioIconState.hover
              : RadioIconState.unchecked,
        ),
      ),
    );
  }
}

enum RadioIconState {
  checked,
  unchecked,
  hover,
}

class _RadioIconView extends StatelessWidget {
  final RadioIconState state;

  const _RadioIconView({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: Spacing.d24,
      height: Spacing.d24,
      curve: Curves.easeOut,
      duration: Durations.medium2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _getBorderColor(context, state),
          width: 2.0,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedScale(
        duration: Durations.medium2,
        curve: Curves.easeOut,
        scale: state != RadioIconState.checked ? 0 : 1.0,
        child: Container(
          width: Spacing.d14,
          height: Spacing.d14,
          decoration: BoxDecoration(
            color: _getBackgroundColor(context, state),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context, RadioIconState state) {
    final isDark = context.theme.brightness == Brightness.dark;
    final theme = context.themeConfigs;
    return switch (state) {
      RadioIconState.checked => theme.colors.primary,
      RadioIconState.unchecked =>
        isDark ? theme.colors.neutral7 : theme.colors.neutral1,
      RadioIconState.hover =>
        isDark ? theme.colors.neutral6 : theme.colors.neutral3,
    };
  }

  Color _getBorderColor(BuildContext context, RadioIconState state) {
    final isDark = context.theme.brightness == Brightness.dark;
    final theme = context.themeConfigs;
    return switch (state) {
      RadioIconState.checked => theme.colors.primary,
      _ => isDark ? theme.colors.neutral3 : theme.colors.neutral4,
    };
  }
}
