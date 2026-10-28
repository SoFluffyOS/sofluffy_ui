import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// How large a [SwitchToggle] draws on desktop.
enum SwitchToggleSize {
  /// The usual size, for settings and forms.
  regular,

  /// A smaller one for dense toolbars, in line with small text. Touch
  /// platforms keep the regular size, so it stays easy to hit.
  compact,
}

class SwitchToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final SwitchToggleSize size;

  const SwitchToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = SwitchToggleSize.regular,
  });

  @override
  State<SwitchToggle> createState() => _SwitchToggleState();
}

class _SwitchToggleState extends State<SwitchToggle>
    with SingleTickerProviderStateMixin {
  final DoughController _doughController = DoughController();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: FluffyDurations.toggle,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeOut,
  );

  late bool _currentValue = widget.value;
  bool _reducesMotion = false;

  bool _isPointerDown = false;
  bool _isHovered = false;
  bool _isDragging = false;
  double _dragPositionX = 0;
  Timer? _tapTimer;

  bool _isCompact(bool isDesktop) =>
      isDesktop && widget.size == SwitchToggleSize.compact;

  double _outerPadding(bool isDesktop) =>
      switch ((isDesktop, _isCompact(isDesktop))) {
        (_, true) => Spacing.d2,
        (true, false) => Spacing.d4,
        (false, _) => Spacing.d8,
      };
  double _innerPadding(bool isDesktop) =>
      switch ((isDesktop, _isCompact(isDesktop))) {
        (_, true) => Spacing.d3,
        (true, false) => Spacing.d4,
        (false, _) => Spacing.d2,
      };
  double _thumbSize(bool isDesktop) =>
      switch ((isDesktop, _isCompact(isDesktop))) {
        (_, true) => Spacing.d10,
        (true, false) => Spacing.d16,
        (false, _) => Spacing.d24,
      };
  double _containerHeight(bool isDesktop) =>
      _thumbSize(isDesktop) +
      (_innerPadding(isDesktop) * 2) +
      (isDesktop ? 0 : Spacing.d4);
  double _containerWidth(bool isDesktop) =>
      switch ((isDesktop, _isCompact(isDesktop))) {
        (_, true) => Spacing.d28,
        (true, false) => Spacing.d40,
        (false, _) => Spacing.d56,
      };

  Radius _sideRadius(bool isDesktop) =>
      switch ((isDesktop, _isCompact(isDesktop))) {
        (_, true) => Radius.circular(Spacing.d8),
        (true, false) => Radius.circular(Spacing.d12),
        (false, _) => Radius.circular(Spacing.d48),
      };
  Radius _roomRadius(bool isDesktop) =>
      switch ((isDesktop, _isCompact(isDesktop))) {
        (_, true) => Radius.circular(Spacing.d2),
        (true, false) => Radius.circular(Spacing.d4),
        (false, _) => Radius.circular(Spacing.d12),
      };
  BorderRadius _trackRadius(bool isDesktop) =>
      switch ((isDesktop, _isCompact(isDesktop))) {
        (_, true) => Spacing.r6,
        (true, false) => Spacing.r8,
        (false, _) => Spacing.r12,
      };

  @override
  void initState() {
    super.initState();
    if (_currentValue) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducesMotion = context.reducesMotion;
  }

  @override
  void didUpdateWidget(covariant SwitchToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value || widget.value != _currentValue) {
      _currentValue = widget.value;
      _moveThumb(on: _currentValue);
    }
  }

  /// Slides the thumb to [on]'s side, or puts it there when motion is
  /// reduced.
  TickerFuture _moveThumb({required bool on}) {
    if (_reducesMotion) {
      _animationController.value = switch (on) {
        true => 1.0,
        false => 0.0,
      };
      return TickerFuture.complete();
    }
    if (on) return _animationController.forward();
    return _animationController.reverse();
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _handleValueChanged(bool newValue) {
    if (!mounted) return;
    if (_currentValue != newValue) {
      _currentValue = newValue;
      widget.onChanged(_currentValue);
      if (mounted) setState(() {});
    }
  }

  Future<void> _handleTap() async {
    final newValue = !_currentValue;
    _tapTimer?.cancel();
    _tapTimer = Timer(
      const Duration(milliseconds: 150),
      () => _handleValueChanged(newValue),
    );
    await _moveThumb(on: newValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;

    final isDesktop = switch (context.fluffyTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };

    final thumbRadius = _thumbSize(isDesktop) / 2;
    final minX = _innerPadding(isDesktop) * (isDesktop ? 1 : 2) + thumbRadius;
    final maxX =
        _containerWidth(isDesktop) -
        _innerPadding(isDesktop) * (isDesktop ? 1 : 2) -
        thumbRadius;
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          _isHovered = true;
          setState(() {});
        },
        onExit: (_) {
          _isHovered = false;
          setState(() {});
        },
        child: GestureDetector(
          onTap: _handleTap,
          onHorizontalDragStart: (details) {
            final dragStartX =
                details.localPosition.dx - _outerPadding(isDesktop);
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
                _containerHeight(isDesktop) / 2,
              ),
              target: Offset(
                _dragPositionX,
                details.localPosition.dy.clamp(
                  -overboundYOffset - _outerPadding(isDesktop),
                  _containerHeight(isDesktop) +
                      _outerPadding(isDesktop) +
                      overboundYOffset,
                ),
              ),
            );
          },
          onHorizontalDragUpdate: (details) {
            final dragUpdateX =
                details.localPosition.dx - _outerPadding(isDesktop);
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
                  -overboundYOffset - _outerPadding(isDesktop),
                  _containerHeight(isDesktop) +
                      _outerPadding(isDesktop) +
                      overboundYOffset,
                ),
              ),
            );
          },
          onHorizontalDragEnd: (details) {
            if (_isDragging) setState(() => _isDragging = false);
            final bool newTargetValue =
                _dragPositionX > (_containerWidth(isDesktop) / 2);
            _doughController.stop();
            final dragProgress = (_dragPositionX - minX) / (maxX - minX);
            _animationController.value = dragProgress.clamp(0.0, 1.0);
            _handleValueChanged(newTargetValue);
            _moveThumb(on: newTargetValue);
          },
          child: Padding(
            padding: EdgeInsets.all(_outerPadding(isDesktop)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  curve: Curves.easeOut,
                  duration: FluffyDurations.toggle,
                  width: _containerWidth(isDesktop),
                  height: _containerHeight(isDesktop),
                  decoration: ShapeDecoration(
                    color: _getBackgroundColor(
                      theme: theme,
                      isDark: isDark,
                      isOn: _isDragging
                          ? _dragPositionX > (_containerWidth(isDesktop) / 2)
                          : _currentValue,
                    ),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: _trackRadius(isDesktop),
                      side: BorderSide(
                        color: _getBorderColor(
                          theme: theme,
                          isDark: isDark,
                          isOn: _isDragging
                              ? _dragPositionX >
                                    (_containerWidth(isDesktop) / 2)
                              : _currentValue,
                        ),
                        width: Spacing.d2,
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
                        ? _dragPositionX > (_containerWidth(isDesktop) / 2)
                        : _currentValue;
                    final thumbColor = _getThumbColor(
                      theme: theme,
                      isOn: showingValue,
                      isDark: isDark,
                    );
                    final realThumbHeight = _isPointerDown
                        ? (_isDragging
                              ? _thumbSize(isDesktop) * 1.0
                              : _thumbSize(isDesktop) * 1.3)
                        : _thumbSize(isDesktop);
                    final realThumbWidth = _isPointerDown
                        ? (_isDragging
                              ? _thumbSize(isDesktop) * 1.4
                              : _thumbSize(isDesktop) * 1.3)
                        : _thumbSize(isDesktop);
                    final thumbBorderRadius = _isPointerDown
                        ? (_isDragging
                              ? (isDesktop ? Spacing.r12 : Spacing.r24)
                              : (showingValue
                                    ? BorderRadius.horizontal(
                                        left: _sideRadius(isDesktop),
                                        right: _roomRadius(isDesktop),
                                      )
                                    : BorderRadius.horizontal(
                                        left: _roomRadius(isDesktop),
                                        right: _sideRadius(isDesktop),
                                      )))
                        : (isDesktop ? Spacing.r4 : Spacing.r8);
                    return Transform.translate(
                      offset: Offset(
                        thumbX - (_containerWidth(isDesktop) / 2),
                        0,
                      ),
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
                            duration: context.motion(FluffyDurations.fast),
                            height: realThumbHeight,
                            width: realThumbWidth,
                            decoration: ShapeDecoration(
                              color: thumbColor,
                              shape: RoundedSuperellipseBorder(
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
      ),
    );
  }

  Color _getBackgroundColor({
    required FluffyThemeData theme,
    required bool isOn,
    required bool isDark,
  }) {
    if (isOn && _isHovered) {
      return theme.colors.primary.withValues(alpha: 0.1);
    }
    if (isOn) {
      return theme.colors.primary.withValues(alpha: 0.2);
    }
    return isDark ? theme.colors.neutral7 : theme.colors.neutral1;
  }

  Color _getBorderColor({
    required FluffyThemeData theme,
    required bool isOn,
    required bool isDark,
  }) {
    if (isOn && _isHovered) {
      return theme.colors.primary.withValues(alpha: 0.8);
    }
    if (isOn) {
      return theme.colors.primary;
    }
    if (_isHovered) {
      return theme.colors.neutral4;
    }
    return isDark ? theme.colors.neutral5 : theme.colors.neutral3;
  }

  Color _getThumbColor({
    required FluffyThemeData theme,
    required bool isOn,
    required bool isDark,
  }) {
    if (isOn && _isHovered) {
      return theme.colors.primary.withValues(alpha: 0.8);
    }
    if (isOn) {
      return theme.colors.primary;
    }
    if (_isHovered) {
      return theme.colors.neutral4;
    }
    return isDark ? theme.colors.neutral5 : theme.colors.neutral3;
  }
}
