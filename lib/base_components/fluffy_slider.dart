import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

enum _SliderArrow { left, right, up, down }

class _SliderArrowIntent extends Intent {
  const _SliderArrowIntent(this.arrow);

  final _SliderArrow arrow;
}

class FluffySlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final FocusNode? focusNode;
  final bool autofocus;

  const FluffySlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.focusNode,
    this.autofocus = false,
  }) : assert(max > min),
       assert(divisions == null || divisions > 0);

  @override
  State<FluffySlider> createState() => _FluffySliderState();
}

class _FluffySliderState extends State<FluffySlider> {
  final FocusNode _internalFocusNode = FocusNode();
  bool _isPointerDown = false;
  bool _showFocusHighlight = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void dispose() {
    _internalFocusNode.dispose();
    super.dispose();
  }

  double _adjustValue(double adjustment, TargetPlatform platform) {
    final min = widget.min;
    final max = widget.max;
    final divisions = widget.divisions;
    final step = switch (divisions) {
      final divisions? => (max - min) / divisions,
      null => switch (platform) {
        TargetPlatform.iOS || TargetPlatform.macOS => (max - min) * 0.1,
        _ => (max - min) * 0.05,
      },
    };
    final adjustedValue = widget.value + step * adjustment;
    if (widget.divisions != null) {
      return (min + ((adjustedValue - min) / step).round() * step)
          .clamp(min, max)
          .toDouble();
    }
    return adjustedValue.clamp(min, max).toDouble();
  }

  Map<ShortcutActivator, Intent> _getArrowShortcuts(
    NavigationMode navigationMode,
  ) {
    return switch (navigationMode) {
      NavigationMode.directional => const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): _SliderArrowIntent(
          _SliderArrow.left,
        ),
        SingleActivator(LogicalKeyboardKey.arrowRight): _SliderArrowIntent(
          _SliderArrow.right,
        ),
      },
      NavigationMode.traditional => const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): _SliderArrowIntent(
          _SliderArrow.left,
        ),
        SingleActivator(LogicalKeyboardKey.arrowRight): _SliderArrowIntent(
          _SliderArrow.right,
        ),
        SingleActivator(LogicalKeyboardKey.arrowUp): _SliderArrowIntent(
          _SliderArrow.up,
        ),
        SingleActivator(LogicalKeyboardKey.arrowDown): _SliderArrowIntent(
          _SliderArrow.down,
        ),
      },
    };
  }

  Object? _handleArrowIntent(_SliderArrowIntent intent, BuildContext context) {
    final shouldIncrease = switch (intent.arrow) {
      _SliderArrow.up => true,
      _SliderArrow.down => false,
      _SliderArrow.left => Directionality.of(context) == TextDirection.rtl,
      _SliderArrow.right => Directionality.of(context) == TextDirection.ltr,
    };
    final adjustment = switch (shouldIncrease) {
      true => 1.0,
      false => -1.0,
    };
    widget.onChanged(_adjustValue(adjustment, context.fluffyTargetPlatform));
    return null;
  }

  String _formatSemanticValue(double value) {
    final fraction = ((value - widget.min) / (widget.max - widget.min)).clamp(
      0.0,
      1.0,
    );
    return '${(fraction * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final min = widget.min;
    final max = widget.max;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final fraction = ((widget.value - min) / (max - min)).clamp(0.0, 1.0);
        final trackInset = Spacing.d8;
        final activeTrackWidth = (trackWidth - trackInset * 2).clamp(
          0.0,
          trackWidth,
        );
        final thumbCenter = trackInset + activeTrackWidth * fraction;
        final thumbLeft = thumbCenter - Spacing.d8;

        void updateFromPosition(double dx) {
          if (activeTrackWidth <= 0) return;

          final newFraction = ((dx - trackInset) / activeTrackWidth).clamp(
            0.0,
            1.0,
          );
          var newValue = min + newFraction * (max - min);
          if (widget.divisions case final divisions?) {
            final step = (max - min) / divisions;
            newValue = (min + ((newValue - min) / step).round() * step)
                .clamp(min, max)
                .toDouble();
          }
          widget.onChanged(newValue);
        }

        final thumbColor = theme.colors.primary;
        final focusRingColor = switch (isDark) {
          true => theme.colors.neutral1,
          false => theme.colors.neutral7,
        };
        final ringColor = switch (isDark) {
          true => theme.colors.neutral5,
          false => theme.colors.neutral3,
        };
        final platform = context.fluffyTargetPlatform;
        final semanticsValue = _formatSemanticValue(widget.value);
        final increasedValue = _formatSemanticValue(_adjustValue(1, platform));
        final decreasedValue = _formatSemanticValue(_adjustValue(-1, platform));

        return FocusableActionDetector(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          mouseCursor: SystemMouseCursors.click,
          includeFocusSemantics: false,
          shortcuts: _getArrowShortcuts(MediaQuery.navigationModeOf(context)),
          actions: {
            _SliderArrowIntent: CallbackAction<_SliderArrowIntent>(
              onInvoke: (intent) => _handleArrowIntent(intent, context),
            ),
          },
          onShowFocusHighlight: (showFocusHighlight) {
            if (_showFocusHighlight != showFocusHighlight) {
              setState(() => _showFocusHighlight = showFocusHighlight);
            }
          },
          child: Listener(
            onPointerDown: (_) {
              _focusNode.requestFocus();
              if (!_isPointerDown) setState(() => _isPointerDown = true);
            },
            onPointerUp: (_) {
              if (_isPointerDown) setState(() => _isPointerDown = false);
            },
            onPointerCancel: (_) {
              if (_isPointerDown) setState(() => _isPointerDown = false);
            },
            child: Semantics(
              slider: true,
              focusable: true,
              focused: _focusNode.hasFocus,
              value: semanticsValue,
              increasedValue: increasedValue,
              decreasedValue: decreasedValue,
              onFocus: _focusNode.requestFocus,
              onIncrease: () => widget.onChanged(_adjustValue(1, platform)),
              onDecrease: () => widget.onChanged(_adjustValue(-1, platform)),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  updateFromPosition(details.localPosition.dx);
                },
                onTapDown: (details) {
                  updateFromPosition(details.localPosition.dx);
                },
                child: SizedBox(
                  width: trackWidth,
                  height: Spacing.d32,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                        left: trackInset,
                        child: Container(
                          height: Spacing.d4,
                          width: activeTrackWidth,
                          decoration: BoxDecoration(
                            color: isDark
                                ? theme.colors.neutral5
                                : theme.colors.neutral3,
                            borderRadius: BorderRadius.circular(Spacing.d2),
                          ),
                        ),
                      ),
                      Positioned(
                        left: trackInset,
                        child: Container(
                          height: Spacing.d4,
                          width: activeTrackWidth * fraction,
                          decoration: BoxDecoration(
                            color: theme.colors.primary,
                            borderRadius: BorderRadius.circular(Spacing.d2),
                          ),
                        ),
                      ),
                      Positioned(
                        left: thumbLeft,
                        child: AnimatedScale(
                          scale: _isPointerDown ? 0.9 : 1,
                          duration: FluffyDurations.fast,
                          curve: Curves.easeOut,
                          child: AnimatedContainer(
                            width: Spacing.d16,
                            height: Spacing.d16,
                            duration: FluffyDurations.fast,
                            curve: Curves.easeOut,
                            decoration: ShapeDecoration(
                              color: thumbColor,
                              shape: RoundedSuperellipseBorder(
                                borderRadius: _isPointerDown
                                    ? Spacing.r4
                                    : Spacing.r6,
                                side: switch (_showFocusHighlight) {
                                  true when _isPointerDown => BorderSide(
                                    color: thumbColor,
                                    width: Spacing.d1,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                  true => BorderSide(
                                    color: focusRingColor,
                                    width: Spacing.d1,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                  false => BorderSide.none,
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
