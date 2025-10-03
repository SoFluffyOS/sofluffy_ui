import 'package:design_system/design_system.dart' show HexColorUtilsExt;
import 'package:flutter/widgets.dart' show Color;

extension HtmlHelper on String {
  HtmlText get html {
    return HtmlText(this);
  }
}

extension HtmlTextExtension on HtmlText {
  HtmlText get h1 {
    return HtmlText('<h1>$text</h1>');
  }

  HtmlText get h2 {
    return HtmlText('<h2>$text</h2>');
  }

  HtmlText get h3 {
    return HtmlText('<h3>$text</h3>');
  }

  HtmlText get h4 {
    return HtmlText('<h4>$text</h4>');
  }

  HtmlText get h5 {
    return HtmlText('<h5>$text</h5>');
  }

  HtmlText get h6 {
    return HtmlText('<h6>$text</h6>');
  }

  HtmlText get br {
    return HtmlText('$text<br>');
  }

  HtmlText get paragraph {
    return HtmlText('<p>$text</p>');
  }

  HtmlText get li {
    return HtmlText('<li>$text</li>');
  }

  /// Wrap with ul with style less padding.
  HtmlText get ul {
    return HtmlText('<ul style="padding: 0 0 0 16px;">$text</ul>');
  }

  HtmlText get ol {
    return HtmlText('<ol>$text</ol>');
  }

  HtmlText get centerParagraph {
    return HtmlText('<p style="text-align: center;">$text</p>');
  }

  HtmlText get bold {
    return HtmlText('<b>$text</b>');
  }

  HtmlText get italic {
    return HtmlText('<i>$text</i>');
  }

  HtmlText addLink(String url) {
    return HtmlText('<a href="$url">$text</a>');
  }

  HtmlText textColor(Color color) {
    return HtmlText(
      '<span style="color: ${color.toWebHex()}">$text</span>',
    );
  }
}

class HtmlText {
  final String text;

  const HtmlText(this.text);

  @override
  String toString() => text;

  HtmlText operator +(HtmlText other) => HtmlText('$text$other');
}
