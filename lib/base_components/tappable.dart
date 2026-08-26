/*
 * Copyright 2020 Simon Pham. All rights reserved.
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

const _animationDuration = 75;

enum TappableState {
  normal(1.0),
  hover(1.025, 0.1),
  focus(1.025, 0.2),
  pressed(0.975, 0.15);

  final double scale;
  final double backgroundOpacity;

  const TappableState(this.scale, [this.backgroundOpacity = 0.0]);

  bool get isHovered =>
      this == TappableState.hover || this == TappableState.pressed;
}

class Tappable extends StatefulWidget {
  final Widget Function(BuildContext context, TappableState state)? builder;
  final Widget? child;

  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final HitTestBehavior? behavior;
  final String? tooltip;

  final bool enableAnimation;
  final bool enableFocusBorder;
  final bool enableHover;
  final bool enableHoverOverlay;

  final FocusNode? focusNode;
  final EdgeInsets hoverOverlayPadding;
  final double? hoverOverlayBorderRadius;
  final Color? hoverOverlayColorTint;

  final ValueChanged<TappableState>? onStateChanged;

  const Tappable({
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.behavior,
    this.tooltip,
    this.enableAnimation = true,
    this.enableFocusBorder = true,
    this.enableHover = false,
    this.enableHoverOverlay = false,
    this.builder,
    this.child,
    this.focusNode,
    this.hoverOverlayPadding = EdgeInsets.zero,
    this.hoverOverlayBorderRadius,
    this.hoverOverlayColorTint,
    this.onStateChanged,
  });

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;
  Duration? _lastTapDownTime;
  Offset? _lastTapDownPosition;
  PointerDeviceKind? _lastTapDeviceKind;
  Duration? _currentTapDownTime;
  Offset? _currentTapDownPosition;
  PointerDeviceKind? _currentTapDeviceKind;
  bool _currentTapIsDouble = false;

  TappableState get _state {
    if (_isPressed) return TappableState.pressed;
    if (_isFocused && widget.enableFocusBorder) return TappableState.focus;
    if (_isHovered && widget.enableHover) return TappableState.hover;
    return TappableState.normal;
  }

  bool get _isInteractive =>
      (widget.onTap ?? widget.onLongPress ?? widget.onDoubleTap) != null;

  bool get _shouldShowBackground =>
      _state.isHovered ||
      _state == TappableState.focus ||
      _state == TappableState.pressed;

  void _setHovered(bool value) {
    if (_isHovered != value) {
      if (mounted) setState(() => _isHovered = value);
      widget.onStateChanged?.call(_state);
    }
  }

  void _setFocused(bool value) {
    if (_isFocused == value) return;
    if (mounted) setState(() => _isFocused = value);
    widget.onStateChanged?.call(_state);
  }

  DateTime? _lastPressTime;
  Timer? _unpressTimer;

  @override
  void didUpdateWidget(covariant Tappable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.onDoubleTap == null) != (widget.onDoubleTap == null)) {
      _resetDoubleTapTracking();
    }
  }

  @override
  void dispose() {
    _unpressTimer?.cancel();
    super.dispose();
  }

  void _setPressed(bool value) {
    _unpressTimer?.cancel();

    if (value) {
      _lastPressTime = DateTime.now();
      if (!_isPressed) {
        if (mounted) setState(() => _isPressed = true);
        widget.onStateChanged?.call(_state);
      }
    } else {
      final now = DateTime.now();
      final diff = _lastPressTime != null
          ? now.difference(_lastPressTime!).inMilliseconds
          : _animationDuration;

      if (diff < _animationDuration) {
        _unpressTimer = Timer(
          Duration(milliseconds: _animationDuration - diff),
          () {
            if (mounted && _isPressed) {
              setState(() => _isPressed = false);
              widget.onStateChanged?.call(_state);
            }
          },
        );
      } else {
        if (_isPressed && mounted) {
          setState(() => _isPressed = false);
          widget.onStateChanged?.call(_state);
        }
      }
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.onDoubleTap == null || event.buttons != kPrimaryButton) {
      _resetDoubleTapTracking();
      return;
    }

    final lastTapDownTime = _lastTapDownTime;
    final lastTapDownPosition = _lastTapDownPosition;
    final elapsed = switch (lastTapDownTime) {
      final lastTime? => event.timeStamp - lastTime,
      null => null,
    };
    final distance = switch (lastTapDownPosition) {
      final lastPosition? => (event.position - lastPosition).distance,
      null => null,
    };

    _currentTapDownTime = event.timeStamp;
    _currentTapDownPosition = event.position;
    _currentTapDeviceKind = event.kind;
    _currentTapIsDouble =
        elapsed != null &&
        elapsed >= Duration.zero &&
        elapsed < kDoubleTapTimeout &&
        distance != null &&
        distance <= kDoubleTapSlop &&
        _lastTapDeviceKind == event.kind;
  }

  void _handleTap() {
    if (_currentTapIsDouble) {
      _resetDoubleTapTracking();
      widget.onDoubleTap?.call();
      return;
    }

    widget.onTap?.call();
    if (widget.onDoubleTap == null) {
      _resetCurrentTap();
      return;
    }

    _lastTapDownTime = _currentTapDownTime;
    _lastTapDownPosition = _currentTapDownPosition;
    _lastTapDeviceKind = _currentTapDeviceKind;
    _resetCurrentTap();
  }

  void _handleTapCancel() {
    if (_currentTapIsDouble) {
      _resetDoubleTapTracking();
    } else {
      _resetCurrentTap();
    }
    widget.onTapCancel?.call();
  }

  void _resetCurrentTap() {
    _currentTapDownTime = null;
    _currentTapDownPosition = null;
    _currentTapDeviceKind = null;
    _currentTapIsDouble = false;
  }

  void _resetDoubleTapTracking() {
    _lastTapDownTime = null;
    _lastTapDownPosition = null;
    _lastTapDeviceKind = null;
    _resetCurrentTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    return Semantics(
      tooltip: widget.tooltip,
      child: FocusableActionDetector(
        enabled:
            _isInteractive || widget.enableHover || widget.enableFocusBorder,
        focusNode: widget.focusNode,
        mouseCursor: _isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: _setHovered,
        onShowFocusHighlight: _setFocused,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
          LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) async {
              if (widget.onTap != null) {
                _setPressed(true);
                await Future.delayed(
                  const Duration(milliseconds: _animationDuration),
                );
                _setPressed(false);
                widget.onTap?.call();
              }
              return null;
            },
          ),
        },
        child: Listener(
          onPointerDown: _handlePointerDown,
          child: GestureDetector(
            behavior: widget.behavior,
            onTap: (widget.onTap ?? widget.onDoubleTap) != null
                ? _handleTap
                : null,
            onLongPress: widget.onLongPress,
            onTapDown: (details) {
              if (widget.onTap != null || widget.onTapDown != null) {
                _setPressed(true);
              }
              widget.onTapDown?.call(details);
            },
            onTapUp: (details) {
              if (widget.onTap != null || widget.onTapUp != null) {
                _setPressed(false);
              }
              widget.onTapUp?.call(details);
            },
            onTapCancel: () {
              if (widget.onTap != null || widget.onTapCancel != null) {
                _setPressed(false);
              }
              _handleTapCancel();
            },
            child: Stack(
              children: [
                AnimatedScale(
                  scale: widget.enableAnimation ? _state.scale : 1.0,
                  duration: const Duration(milliseconds: _animationDuration),
                  child: Container(
                    color: FluffyColors.transparent,
                    child:
                        widget.builder?.call(context, _state) ?? widget.child,
                  ),
                ),
                if (widget.enableHoverOverlay)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedScale(
                        scale: widget.enableAnimation ? _state.scale : 1.0,
                        duration: const Duration(
                          milliseconds: _animationDuration,
                        ),
                        child: AnimatedContainer(
                          margin: widget.hoverOverlayPadding,
                          duration: const Duration(
                            milliseconds: _animationDuration,
                          ),
                          decoration: _shouldShowBackground
                              ? ShapeDecoration(
                                  shape: RoundedSuperellipseBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        widget.hoverOverlayBorderRadius ??
                                            Spacing.d12,
                                      ),
                                    ),
                                  ),
                                  color:
                                      (widget.hoverOverlayColorTint ??
                                              theme.colors.primary)
                                          .withValues(
                                            alpha: _state.backgroundOpacity,
                                          ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                if (_state == TappableState.focus && widget.enableFocusBorder)
                  Positioned.fill(
                    child: Transform.scale(
                      scale: _state.scale,
                      child: Container(
                        margin: widget.hoverOverlayPadding,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colors.primary.withValues(alpha: 0.5),
                            width: Spacing.d2,
                          ),
                          borderRadius: widget.hoverOverlayBorderRadius != null
                              ? BorderRadius.circular(
                                  widget.hoverOverlayBorderRadius!,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
