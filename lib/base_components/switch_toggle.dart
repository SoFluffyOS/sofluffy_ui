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
  bool _isDragging = false;
  double _dragPositionX = 0;

  double get _outerPadding => Spacing.d8;
  double get _innerPadding => Spacing.d2;
  double get _thumbSize => Spacing.d24;
  double get _containerHeight => Spacing.d28 + (Spacing.d2 * 2);
  double get _containerWidth => Spacing.d56;

  static const _sideRadius = SmoothRadius(
    cornerRadius: 48.0,
    cornerSmoothing: 1.0,
  );
  static const _roomRadius = SmoothRadius(
    cornerRadius: 12.0,
    cornerSmoothing: 1.0,
  );

  @override
  void initState() {
    super.initState();
    if (_currentValue) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant SwitchToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
      if (_currentValue) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleValueChanged(bool newValue) {
    if (_currentValue != newValue) {
      _currentValue = newValue;
      widget.onChanged(_currentValue);
      setState(() {});
    }
  }

  Future<void> _handleTap() async {
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConfigs().theme;
    final isDark = context.theme.brightness == Brightness.dark;
    final thumbRadius = _thumbSize / 2;
    final minX = _innerPadding * 2 + thumbRadius;
    final maxX = _containerWidth - _innerPadding * 2 - thumbRadius;
    final overboundXOffset = thumbRadius / 2;
    final overboundYOffset = thumbRadius;

    return Listener(
      onPointerDown: (_) {
        if (!_isPointerDown) {
          _isPointerDown = true;
          setState(() {});
        }
      },
      onPointerUp: (_) {
        if (_isPointerDown) {
          _isPointerDown = false;
          setState(() {});
        }
      },
      onPointerCancel: (_) {
        if (_isPointerDown) {
          _isPointerDown = false;
          setState(() {});
        }
      },
      child: GestureDetector(
        onTap: _handleTap,
        onHorizontalDragStart: (details) {
          final dragStartX = details.localPosition.dx - _outerPadding;
          _animationController.stop();
          if (!_isDragging) setState(() => _isDragging = true);
          final originOffset = overboundXOffset * (_currentValue ? -1 : 1);
          _dragPositionX = dragStartX.clamp(
            minX - overboundXOffset,
            maxX + overboundXOffset,
          );
          _doughController.start(
            origin: Offset(
              lerpDouble(minX, maxX, _animation.value)! + originOffset,
              _containerHeight / 2,
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
          final dragUpdateX = details.localPosition.dx - _outerPadding;
          final newDragPositionX = dragUpdateX.clamp(
            minX - overboundXOffset,
            maxX + overboundXOffset,
          );
          if (_dragPositionX != newDragPositionX) {
            setState(() {
              _dragPositionX = newDragPositionX;
            });
          }
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
          if (_isDragging) setState(() => _isDragging = false);
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
                  color: _getBackgroundColor(
                    theme: theme,
                    isDark: isDark,
                    isOn: _isDragging
                        ? _dragPositionX > (_containerWidth / 2)
                        : _currentValue,
                  ),
                  shape: SmoothRectangleBorder(
                    borderRadius: Spacing.smoothR12,
                    side: BorderSide(
                      color: _getBorderColor(
                        theme: theme,
                        isDark: isDark,
                        isOn: _isDragging
                            ? _dragPositionX > (_containerWidth / 2)
                            : _currentValue,
                      ),
                      width: 2.0,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final thumbX = _isDragging
                      ? _dragPositionX
                      : lerpDouble(minX, maxX, _animation.value)!;
                  final showingValue = _isDragging
                      ? _dragPositionX > (_containerWidth / 2)
                      : _currentValue;
                  final thumbColor = showingValue
                      ? theme.colors.primary
                      : isDark
                      ? theme.colors.neutral6
                      : theme.colors.neutral3;
                  final realThumbHeight = _isPointerDown
                      ? (_isDragging ? _thumbSize * 1.0 : _thumbSize * 1.3)
                      : _thumbSize;
                  final realThumbWidth = _isPointerDown
                      ? (_isDragging ? _thumbSize * 1.4 : _thumbSize * 1.3)
                      : _thumbSize;
                  final thumbBorderRadius = _isPointerDown
                      ? (_isDragging
                            ? Spacing.smoothR24
                            : (showingValue
                                  ? const SmoothBorderRadius.horizontal(
                                      left: _sideRadius,
                                      right: _roomRadius,
                                    )
                                  : const SmoothBorderRadius.horizontal(
                                      left: _roomRadius,
                                      right: _sideRadius,
                                    )))
                      : Spacing.smoothR8;
                  return Transform.translate(
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
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor({
    required AppTheme theme,
    required bool isOn,
    required bool isDark,
  }) {
    if (isOn) {
      return theme.colors.primary.withValues(alpha: 0.2);
    }
    return isDark ? theme.colors.neutral7 : theme.colors.neutral1;
  }

  Color _getBorderColor({
    required AppTheme theme,
    required bool isOn,
    required bool isDark,
  }) {
    if (isOn) {
      return theme.colors.primary;
    }
    return isDark ? theme.colors.neutral6 : theme.colors.neutral3;
  }
}
