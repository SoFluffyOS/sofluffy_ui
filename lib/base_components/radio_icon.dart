import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

part 'radio_list_tile.dart';

class RadioIcon<T> extends StatefulWidget {
  final T? groupValue;
  final T value;
  final ValueChanged<T>? onChanged;
  final double size;
  final EdgeInsetsGeometry? padding;

  RadioIcon({
    super.key,
    required this.groupValue,
    required this.value,
    this.onChanged,
    double? size,
    this.padding,
  }) : size = size ?? Spacing.d24;

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
        widget.onChanged?.call(widget.value);
      },
      child: Padding(
        padding: widget.padding ?? EdgeInsets.all(Spacing.d8),
        child: _RadioIconView(
          state: _isSelected
              ? RadioIconState.checked
              : _isHovering
              ? RadioIconState.hover
              : RadioIconState.unchecked,
          size: widget.size,
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
  final double size;

  _RadioIconView({
    required this.state,
    double? size,
  }) : size = size ?? Spacing.d24;

  @override
  Widget build(BuildContext context) {
    final innerSize = (size * 14.0 / 24.0).roundToDouble();
    return AnimatedContainer(
      width: size,
      height: size,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _getBorderColor(context, state),
          width: size < Spacing.d20 ? 1.5 : 2.0,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        scale: state != RadioIconState.checked ? 0 : 1.0,
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            color: _getBackgroundColor(context, state),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context, RadioIconState state) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    return switch (state) {
      RadioIconState.checked => theme.colors.primary,
      RadioIconState.unchecked =>
        isDark ? theme.colors.neutral7 : theme.colors.neutral1,
      RadioIconState.hover =>
        isDark ? theme.colors.neutral6 : theme.colors.neutral3,
    };
  }

  Color _getBorderColor(BuildContext context, RadioIconState state) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    return switch (state) {
      RadioIconState.checked => theme.colors.primary,
      _ => isDark ? theme.colors.neutral3 : theme.colors.neutral4,
    };
  }
}
