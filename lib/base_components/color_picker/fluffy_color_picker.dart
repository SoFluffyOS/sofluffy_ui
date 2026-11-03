import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// Picks a color: its saturation and brightness in a square, its hue and
/// alpha on strips, or its hex typed. A header shows the [original] color,
/// which a click goes back to, beside the picked one with its [label].
///
/// [onChangeStart] and [onChangeEnd] bracket each gesture, a drag or a key
/// press, so a caller can group what it does with every [onChanged].
class FluffyColorPicker extends StatefulWidget {
  const FluffyColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
    this.original,
    this.label,
    this.onLabelTap,
    this.labelTooltip,
    this.showAlpha = true,
    this.onChangeStart,
    this.onChangeEnd,
  });

  final Color color;
  final ValueChanged<Color> onChanged;
  final Color? original;

  /// The picked color as text in the header; its hex when null.
  final String? label;
  final VoidCallback? onLabelTap;
  final String? labelTooltip;
  final bool showAlpha;
  final VoidCallback? onChangeStart;
  final VoidCallback? onChangeEnd;

  @override
  State<FluffyColorPicker> createState() => _FluffyColorPickerState();
}

class _FluffyColorPickerState extends State<FluffyColorPicker> {
  late HSVColor _hsv = HSVColor.fromColor(widget.color);
  late final _hex = TextEditingController(text: _hexOf(widget.color));
  final _hexFocus = FocusNode(debugLabel: 'ColorPickerHex');

  String _hexOf(Color color) =>
      ColorHex.format(color, withAlpha: widget.showAlpha && color.a < 1);

  @override
  void initState() {
    super.initState();
    _hexFocus.addListener(_onHexFocusChanged);
  }

  @override
  void didUpdateWidget(FluffyColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color == _hsv.toColor()) return;
    _hsv = _keepingHue(HSVColor.fromColor(widget.color));
    if (!_hexFocus.hasFocus) _hex.text = _hexOf(widget.color);
  }

  @override
  void dispose() {
    _hexFocus
      ..removeListener(_onHexFocusChanged)
      ..dispose();
    _hex.dispose();
    super.dispose();
  }

  /// [next] with the hue as it was when [next] has none to speak of, a gray
  /// or black, so the square keeps its hue.
  HSVColor _keepingHue(HSVColor next) {
    final hasNoHue = next.saturation == 0 || next.value == 0;
    if (!hasNoHue) return next;
    return next.withHue(_hsv.hue);
  }

  void _onHexFocusChanged() {
    if (_hexFocus.hasFocus) return;
    _hex.text = _hexOf(_hsv.toColor());
  }

  void _pick(HSVColor next) {
    setState(() => _hsv = next);
    final color = next.toColor();
    if (!_hexFocus.hasFocus) _hex.text = _hexOf(color);
    widget.onChanged(color);
  }

  /// While typing, only a full `#RRGGBB` or `#RRGGBBAA` applies: `#123` on
  /// its way to `#123456` is not meant as `#112233`.
  void _onHexTyped(String text) {
    final digits = text.trim().replaceFirst('#', '').length;
    if (digits != 6 && digits != 8) return;
    _onHexChanged(text);
  }

  void _onHexChanged(String text) {
    final color = ColorHex.parse(text);
    if (color == null || color == _hsv.toColor()) return;
    final next = switch (widget.showAlpha) {
      true => color,
      false => color.withValues(alpha: _hsv.alpha),
    };
    widget.onChangeStart?.call();
    setState(() => _hsv = _keepingHue(HSVColor.fromColor(next)));
    widget.onChanged(next);
    widget.onChangeEnd?.call();
  }

  void _revert() {
    final original = widget.original;
    if (original == null) return;
    widget.onChangeStart?.call();
    _pick(_keepingHue(HSVColor.fromColor(original)));
    widget.onChangeEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final color = _hsv.toColor();
    final opaque = color.withValues(alpha: 1);
    final theme = context.fluffyTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColorPickerHeader(
          color: color,
          label: widget.label ?? _hexOf(color),
          original: widget.original,
          onRevert: _revert,
          onLabelTap: widget.onLabelTap,
          labelTooltip: widget.labelTooltip,
        ),
        Spacing.v8,
        AspectRatio(
          aspectRatio: 1.6,
          child: SaturationBox(
            color: _hsv,
            onChanged: _pick,
            onChangeStart: widget.onChangeStart,
            onChangeEnd: widget.onChangeEnd,
          ),
        ),
        Spacing.v8,
        ColorStrip(
          value: _hsv.hue / 360,
          label: 'Hue',
          colors: [
            for (var hue = 0; hue <= 360; hue += 60)
              HSVColor.fromAHSV(1, hue.toDouble(), 1, 1).toColor(),
          ],
          thumbColor: HSVColor.fromAHSV(1, _hsv.hue, 1, 1).toColor(),
          onChanged: (value) => _pick(_hsv.withHue(value * 360)),
          onChangeStart: widget.onChangeStart,
          onChangeEnd: widget.onChangeEnd,
        ),
        if (widget.showAlpha) ...[
          Spacing.v8,
          ColorStrip(
            value: _hsv.alpha,
            label: 'Opacity',
            checkerboard: true,
            colors: [opaque.withValues(alpha: 0), opaque],
            thumbColor: color,
            onChanged: (value) => _pick(_hsv.withAlpha(value)),
            onChangeStart: widget.onChangeStart,
            onChangeEnd: widget.onChangeEnd,
          ),
        ],
        Spacing.v8,
        InputText(
          controller: _hex,
          focusNode: _hexFocus,
          maxLines: 1,
          textStyle: theme.typography.caption1.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          onChanged: _onHexTyped,
          onSubmitted: _onHexChanged,
        ),
      ],
    );
  }
}
