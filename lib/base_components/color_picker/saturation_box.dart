import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// A color's saturation across and value down, for its hue: drag, click,
/// or move with the arrow keys, a percent a press (ten with Shift).
class SaturationBox extends StatefulWidget {
  const SaturationBox({
    super.key,
    required this.color,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final VoidCallback? onChangeStart;
  final VoidCallback? onChangeEnd;

  @override
  State<SaturationBox> createState() => _SaturationBoxState();
}

class _SaturationBoxState extends State<SaturationBox> {
  final _focusNode = FocusNode(debugLabel: 'SaturationBox');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _pick(Offset local, Size size) {
    if (size.isEmpty) return;
    final saturation = (local.dx / size.width).clamp(0.0, 1.0);
    final value = 1 - (local.dy / size.height).clamp(0.0, 1.0);
    widget.onChanged(
      widget.color.withSaturation(saturation).withValue(value),
    );
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final step = switch (HardwareKeyboard.instance.isShiftPressed) {
      true => 0.1,
      false => 0.01,
    };
    final (dx, dy) = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowLeft => (-step, 0.0),
      LogicalKeyboardKey.arrowRight => (step, 0.0),
      LogicalKeyboardKey.arrowUp => (0.0, step),
      LogicalKeyboardKey.arrowDown => (0.0, -step),
      _ => (0.0, 0.0),
    };
    if (dx == 0 && dy == 0) return KeyEventResult.ignored;
    final color = widget.color;
    widget.onChangeStart?.call();
    widget.onChanged(
      color
          .withSaturation((color.saturation + dx).clamp(0.0, 1.0))
          .withValue((color.value + dy).clamp(0.0, 1.0)),
    );
    widget.onChangeEnd?.call();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return Focus(
          focusNode: _focusNode,
          onKeyEvent: _onKey,
          child: Semantics(
            label: 'Saturation and brightness',
            value:
                '${(widget.color.saturation * 100).round()}%, '
                '${(widget.color.value * 100).round()}%',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (details) {
                _focusNode.requestFocus();
                widget.onChangeStart?.call();
                _pick(details.localPosition, size);
              },
              onPanUpdate: (details) => _pick(details.localPosition, size),
              onPanEnd: (_) => widget.onChangeEnd?.call(),
              onPanCancel: () => widget.onChangeEnd?.call(),
              child: MouseRegion(
                cursor: SystemMouseCursors.precise,
                child: ClipRRect(
                  borderRadius: Spacing.r6,
                  child: CustomPaint(
                    size: size,
                    painter: _SaturationPainter(widget.color),
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

class _SaturationPainter extends CustomPainter {
  const _SaturationPainter(this.color);

  final HSVColor color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final hue = HSVColor.fromAHSV(1, color.hue, 1, 1).toColor();
    canvas
      ..drawRect(rect, Paint()..color = hue)
      ..drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xffffffff), Color(0x00ffffff)],
          ).createShader(rect),
      )
      ..drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x00000000), Color(0xff000000)],
          ).createShader(rect),
      );
    final thumb = Offset(
      color.saturation * size.width,
      (1 - color.value) * size.height,
    );
    final opaque = color.withAlpha(1).toColor();
    canvas
      ..drawCircle(thumb, Spacing.d6, Paint()..color = opaque)
      ..drawCircle(
        thumb,
        Spacing.d6,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = Spacing.d2
          ..color = const Color(0xffffffff),
      )
      ..drawCircle(
        thumb,
        Spacing.d6 + Spacing.d1,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = Spacing.d1
          ..color = const Color(0x66000000),
      );
  }

  @override
  bool shouldRepaint(_SaturationPainter oldDelegate) =>
      oldDelegate.color != color;
}
