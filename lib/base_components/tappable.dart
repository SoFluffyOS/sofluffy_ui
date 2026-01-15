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

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _animationDuration = 75;

enum TappableState {
  normal(1.0),
  hover(1.025, 0.1),
  focus(1.025, 0.2),
  pressed(0.975);

  final double scale;
  final double backgroundOpacity;

  const TappableState(this.scale, [this.backgroundOpacity = 0.0]);
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

  final EdgeInsets? hoverOverlayPadding;
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
  TappableState _lastState = TappableState.normal;
  TappableState _state = TappableState.normal;

  bool get _isInteractive =>
      (widget.onTap ?? widget.onLongPress ?? widget.onDoubleTap) != null;

  bool get _shouldShowBackground =>
      _state == TappableState.hover || _state == TappableState.focus;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: MouseRegion(
        cursor: _isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onHover: (_) {
          if (widget.enableHover && _state != TappableState.focus) {
            hover();
          }
        },
        onEnter: (_) {
          if (widget.enableHover && _state != TappableState.focus) {
            hover();
          }
        },
        onExit: (_) {
          if (widget.enableHover && _state != TappableState.focus) {
            _lastState = TappableState.normal;
            reset();
          }
        },
        child: Focus(
          descendantsAreFocusable: false,
          descendantsAreTraversable: false,
          canRequestFocus: _isInteractive,
          focusNode: widget.focusNode,
          onFocusChange: (bool hasFocus) {
            if (hasFocus) {
              focus();
            } else {
              reset();
            }
          },
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space) {
                pressedDown();
                return KeyEventResult.handled;
              }
            } else if (event is KeyUpEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space) {
                bounceUp();
                if (widget.onTap != null) {
                  widget.onTap?.call();
                  return KeyEventResult.handled;
                }
              }
            }

            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            behavior: widget.behavior,
            onTap: () async {
              if (widget.onTap == null) {
                return;
              }
              widget.onTap?.call();
              await pressedDown();
              unawaited(bounceUp());
            },
            onDoubleTap: widget.onDoubleTap,
            onLongPress: widget.onLongPress,
            onTapDown: (TapDownDetails details) {
              if (widget.onTap == null) {
                return;
              }
              pressedDown();
              if (widget.onTapDown != null) {
                widget.onTapDown?.call(details);
              }
            },
            onTapUp: (TapUpDetails details) {
              if (widget.onTap == null) {
                return;
              }
              widget.onTapUp?.call(details);
              bounceUp();
            },
            onTapCancel: () {
              if (widget.onTap == null) {
                return;
              }
              bounceUp();
              widget.onTapCancel?.call();
            },
            child: Stack(
              children: [
                AnimatedScale(
                  scale: widget.enableAnimation ? _state.scale : 1.0,
                  duration: const Duration(milliseconds: _animationDuration),
                  child: Container(
                    color: Colors.transparent,
                    child:
                        widget.builder?.call(context, _state) ?? widget.child,
                  ),
                ),
                if (widget.enableHoverOverlay)
                  Positioned.fill(
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
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius:
                                          widget.hoverOverlayBorderRadius ??
                                          12.0,
                                      cornerSmoothing: 1.0,
                                    ),
                                  ),
                                ),
                                color:
                                    (widget.hoverOverlayColorTint ??
                                            context.theme.primaryColor)
                                        .withValues(
                                          alpha: _state.backgroundOpacity,
                                        ),
                              )
                            : null,
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
                            color: context.theme.focusColor,
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

  Future<void> pressedDown() {
    _lastState = _state;
    _state = TappableState.pressed;
    if (mounted) {
      setState(() {});
    }
    widget.onStateChanged?.call(_state);
    return Future.delayed(const Duration(milliseconds: _animationDuration));
  }

  Future<void> bounceUp() {
    reset();
    return Future.delayed(const Duration(milliseconds: _animationDuration));
  }

  void hover() {
    _state = TappableState.hover;
    _lastState = TappableState.hover;
    if (mounted) {
      setState(() {});
    }
    widget.onStateChanged?.call(_state);
  }

  void focus() {
    _state = TappableState.focus;
    if (mounted) {
      setState(() {});
    }
    widget.onStateChanged?.call(_state);
  }

  void reset() {
    if (_lastState == TappableState.hover) {
      _state = TappableState.hover;
    } else {
      _state = TappableState.normal;
    }
    if (mounted) {
      setState(() {});
    }
    widget.onStateChanged?.call(_state);
  }
}
