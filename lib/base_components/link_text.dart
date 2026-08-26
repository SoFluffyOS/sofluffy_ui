import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class LinkText extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;

  final String? hint;
  final bool showUnderlineWhenNormal;

  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;

  const LinkText(
    this.text, {
    super.key,
    this.onTap,
    this.hint,
    this.showUnderlineWhenNormal = true,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
  });

  @override
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Tappable(
      tooltip: widget.hint ?? widget.text,
      onTap: widget.onTap,
      enableHover: true,
      onStateChanged: (state) {
        _isHovered.value = state.isHovered;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _isHovered,
        builder: (context, isHovered, _) {
          final style = widget.style ?? const TextStyle();
          return Text(
            widget.text,
            style: style.copyWith(
              fontStyle: isHovered ? FontStyle.italic : FontStyle.normal,
              color: isHovered ? context.fluffyTheme.colors.primary : null,
              decoration: switch (widget.showUnderlineWhenNormal) {
                true => TextDecoration.underline,
                false => isHovered ? TextDecoration.underline : null,
              },
              decorationColor: isHovered
                  ? context.fluffyTheme.colors.primary
                  : null,
              decorationThickness: isHovered ? 2.0 : 1.0,
            ),
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            locale: widget.locale,
            softWrap: widget.softWrap,
            overflow: widget.overflow,
            textScaler: widget.textScaler,
            maxLines: widget.maxLines,
            semanticsLabel: widget.semanticsLabel,
            textWidthBasis: widget.textWidthBasis,
          );
        },
      ),
    );
  }
}
