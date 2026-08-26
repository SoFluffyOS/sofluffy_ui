import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class LoadingText extends StatelessWidget {
  final int loadingLength;
  final String? text;

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

  const LoadingText(
    this.text, {
    this.loadingLength = 5,
    super.key,
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
  Widget build(BuildContext context) {
    final text = this.text;
    if (text == null) {
      final textStyle = (style ?? const TextStyle());
      final fontSize = textStyle.fontSize ?? 14;
      final width = fontSize * loadingLength;
      final height = fontSize * 1.5;
      return LoadingBox(
        width: width,
        height: height,
      );
    }
    return Text(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
    );
  }
}
