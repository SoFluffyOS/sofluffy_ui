import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// A horizontal strip picking a [value] from 0 to 1 along [colors], such as
/// a hue or an alpha: drag, click, or the arrow keys, a percent a press
/// (ten with Shift). With [checkerboard], the colors show over squares, so
/// transparency does.
class ColorStrip extends StatefulWidget {
  const ColorStrip({
    super.key,
    required this.value,
    required this.colors,
    required this.thumbColor,
    required this.label,
    required this.onChanged,
    this.checkerboard = false,
    this.onChangeStart,
    this.onChangeEnd,
  });

  final double value;
  final List<Color> colors;

  /// The color at [value], filling the thumb.
  final Color thumbColor;

  /// What the strip picks, for screen readers.
  final String label;
  final ValueChanged<double> onChanged;
  final bool checkerboard;
  final VoidCallback? onChangeStart;
  final VoidCallback? onChangeEnd;

  @override
  State<ColorStrip> createState() => _ColorStripState();
}

class _ColorStripState extends State<ColorStrip> {
  final _focusNode = FocusNode(debugLabel: 'ColorStrip');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _pick(double dx, double width) {
    if (width <= 0) return;
    widget.onChanged((dx / width).clamp(0.0, 1.0));
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final step = switch (HardwareKeyboard.instance.isShiftPressed) {
      true => 0.1,
      false => 0.01,
    };
    final delta = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.arrowDown => -step,
      LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.arrowUp => step,
      _ => 0.0,
    };
    if (delta == 0) return KeyEventResult.ignored;
    widget.onChangeStart?.call();
    widget.onChanged((widget.value + delta).clamp(0.0, 1.0));
    widget.onChangeEnd?.call();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final height = Spacing.d12;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbLeft = (widget.value * width - height / 2).clamp(
          0.0,
          (width - height).clamp(0.0, double.infinity),
        );
        return Focus(
          focusNode: _focusNode,
          onKeyEvent: _onKey,
          child: Semantics(
            slider: true,
            label: widget.label,
            value: '${(widget.value * 100).round()}%',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragDown: (details) {
                _focusNode.requestFocus();
                widget.onChangeStart?.call();
                _pick(details.localPosition.dx, width);
              },
              onHorizontalDragUpdate: (details) =>
                  _pick(details.localPosition.dx, width),
              onHorizontalDragEnd: (_) => widget.onChangeEnd?.call(),
              onHorizontalDragCancel: () => widget.onChangeEnd?.call(),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(height / 2),
                          child: CustomPaint(
                            painter: switch (widget.checkerboard) {
                              true => CheckerboardPainter(square: height / 2),
                              false => null,
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: widget.colors),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: thumbLeft,
                        top: 0,
                        width: height,
                        height: height,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: widget.thumbColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xffffffff),
                              width: Spacing.d2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x66000000),
                                blurRadius: Spacing.d2,
                              ),
                            ],
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
