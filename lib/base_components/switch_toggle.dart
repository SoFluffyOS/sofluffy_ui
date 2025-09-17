import 'dart:ui';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SwitchToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchToggle({super.key, required this.value, required this.onChanged});

  @override
  State<SwitchToggle> createState() => _SwitchToggleState();
}

class _SwitchToggleState extends State<SwitchToggle>
    with SingleTickerProviderStateMixin {
  final DoughController _doughController = DoughController();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeOut,
  );

  late bool _currentValue = widget.value;

  bool _isPointerDown = false;
  bool _isDraggingDisabled = false;
  bool _isDragging = false;
  double _dragPositionX = 0;

  double get _outerPadding => Spacing.d8;
  double get _innerPadding => Spacing.d2;
  double get _thumbSize => Spacing.d24;
  double get _containerHeight => Spacing.d28 + (Spacing.d2 * 2);
  double get _containerWidth => Spacing.d56;

  @override
  void initState() {
    super.initState();

    if (_currentValue) {
      _animationController.value = 1.0;
    }

    _animationController.addListener(() {
      if (!_isDragging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleValueChanged(bool newValue) {
    if (_currentValue != newValue) {
      _currentValue = newValue;
      setState(() {});
      widget.onChanged(_currentValue);
    }
  }

  Future<void> _handleTap() async {
    _isDraggingDisabled = true;
    final newValue = !_currentValue;
    Future.delayed(
      const Duration(milliseconds: 150),
      () => _handleValueChanged(newValue),
    );
    if (newValue) {
      await _animationController.forward();
    } else {
      await _animationController.reverse();
    }
    _isDraggingDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final currentValue = _currentValue;

    final thumbRadius = _thumbSize / 2;
    final minX = _innerPadding * 2 + thumbRadius;
    final maxX = _containerWidth - _innerPadding * 2 - thumbRadius;

    final double thumbX = _isDragging
        ? _dragPositionX
        : lerpDouble(minX, maxX, _animation.value)!;

    final middleY = _containerHeight / 2;
    final origin = Offset(thumbX, middleY);
    final overboundXOffset = thumbRadius / 2;
    final overboundYOffset = thumbRadius;

    final predictedNextValue = _dragPositionX > (_containerWidth / 2);
    final showingValue = switch (_isDragging) {
      true => predictedNextValue,
      false => currentValue,
    };

    final thumbColor = showingValue
        ? ThemeConfigs().theme.colors.primary
        : isDark
        ? ThemeConfigs().theme.colors.neutral6
        : ThemeConfigs().theme.colors.neutral3;

    final realThumbHeight = switch (_isPointerDown) {
      true when !_isDragging => _thumbSize * 1.3,
      true when _isDragging => _thumbSize * 1.0,
      _ => _thumbSize,
    };
    final realThumbWidth = switch (_isPointerDown) {
      true when !_isDragging => _thumbSize * 1.3,
      true when _isDragging => _thumbSize * 1.4,
      _ => _thumbSize,
    };

    const sideRadius = SmoothRadius(
      cornerRadius: 48.0,
      cornerSmoothing: 1.0,
    );
    const roomRadius = SmoothRadius(
      cornerRadius: 12.0,
      cornerSmoothing: 1.0,
    );
    final thumbBorderRadius = switch (_isPointerDown) {
      true when !_isDragging && currentValue =>
        const SmoothBorderRadius.horizontal(
          left: sideRadius,
          right: roomRadius,
        ),
      true when !_isDragging && !currentValue =>
        const SmoothBorderRadius.horizontal(
          left: roomRadius,
          right: sideRadius,
        ),
      true when _isDragging => Spacing.smoothR24,
      _ => Spacing.smoothR8,
    };
    return Listener(
      onPointerDown: (_) {
        _isPointerDown = true;
        setState(() {});
      },
      onPointerUp: (_) {
        _isPointerDown = false;
        setState(() {});
      },
      onPointerCancel: (_) {
        _isPointerDown = false;
        setState(() {});
      },
      child: GestureDetector(
        onTap: _handleTap,
        onHorizontalDragStart: (details) {
          if (_isDraggingDisabled) {
            return;
          }

          final dragStartX = details.localPosition.dx - _outerPadding;
          _animationController.stop();
          setState(() => _isDragging = true);
          final originOffset = overboundXOffset * (currentValue ? -1 : 1);
          _dragPositionX = dragStartX.clamp(
            minX - overboundXOffset,
            maxX + overboundXOffset,
          );
          _doughController.start(
            origin: Offset(
              origin.dx + originOffset,
              origin.dy,
            ),
            target: Offset(
              _dragPositionX,
              details.localPosition.dy.clamp(
                -overboundYOffset - _outerPadding,
                _containerHeight + _outerPadding + overboundYOffset,
              ),
            ),
          );
        },
        onHorizontalDragUpdate: (details) {
          if (_isDraggingDisabled) {
            return;
          }

          final dragUpdateX = details.localPosition.dx - _outerPadding;
          setState(() {
            _dragPositionX = dragUpdateX.clamp(
              minX - overboundXOffset,
              maxX + overboundXOffset,
            );
          });
          _doughController.update(
            target: Offset(
              _dragPositionX,
              details.localPosition.dy.clamp(
                -overboundYOffset - _outerPadding,
                _containerHeight + _outerPadding + overboundYOffset,
              ),
            ),
          );
        },
        onHorizontalDragEnd: (details) {
          if (_isDraggingDisabled) {
            return;
          }

          setState(() => _isDragging = false);

          final bool newTargetValue = _dragPositionX > (_containerWidth / 2);

          _doughController.stop();

          final dragProgress = (_dragPositionX - minX) / (maxX - minX);
          _animationController.value = dragProgress.clamp(0.0, 1.0);

          _handleValueChanged(newTargetValue);

          if (newTargetValue) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        },
        child: Padding(
          padding: EdgeInsets.all(_outerPadding),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
                width: _containerWidth,
                height: _containerHeight,
                decoration: ShapeDecoration(
                  color: _getBackgroundColor(context, showingValue),
                  shape: SmoothRectangleBorder(
                    borderRadius: Spacing.smoothR12,
                    side: BorderSide(
                      color: _getBorderColor(context, showingValue),
                      width: 2.0,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(thumbX - (_containerWidth / 2), 0),
                child: DoughRecipe(
                  data: DoughRecipe.of(context).copyWith(
                    expansion: 1.125,
                    usePerspectiveWarp: true,
                    perspectiveWarpDepth: 2,
                  ),
                  child: Dough(
                    controller: _doughController,
                    child: AnimatedContainer(
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 200),
                      height: realThumbHeight,
                      width: realThumbWidth,
                      decoration: ShapeDecoration(
                        color: thumbColor,
                        shape: SmoothRectangleBorder(
                          borderRadius: thumbBorderRadius,
                        ),
                        shadows: _isDragging
                            ? [
                                BoxShadow(
                                  color: thumbColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context, bool isOn) {
    final isDark = context.theme.brightness == Brightness.dark;
    if (isOn) {
      return ThemeConfigs().theme.colors.primary.withValues(alpha: 0.2);
    }
    return isDark
        ? ThemeConfigs().theme.colors.neutral7
        : ThemeConfigs().theme.colors.neutral1;
  }

  Color _getBorderColor(BuildContext context, bool isOn) {
    final isDark = context.theme.brightness == Brightness.dark;
    if (isOn) {
      return ThemeConfigs().theme.colors.primary;
    }
    return isDark
        ? ThemeConfigs().theme.colors.neutral6
        : ThemeConfigs().theme.colors.neutral3;
  }
}
