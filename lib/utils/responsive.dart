import 'package:flutter/widgets.dart';

enum ScreenSize {
  small(0),
  normal(375),
  large(768),
  larger(1024),
  extraLarge(1200);

  final int breakpoint;

  const ScreenSize(this.breakpoint);

  static ScreenSize of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.width < normal.breakpoint) {
      return ScreenSize.small;
    }

    if (size.width < large.breakpoint) {
      return ScreenSize.normal;
    }

    if (size.width < larger.breakpoint) {
      return ScreenSize.large;
    }

    if (size.width < extraLarge.breakpoint) {
      return ScreenSize.larger;
    }

    return ScreenSize.extraLarge;
  }
}

extension ScreenSizeExtension on ScreenSize {
  bool get isHandyDevice => this <= ScreenSize.normal;

  bool get isSmallDevice => this == ScreenSize.small;

  bool get isLargeDevice => this >= ScreenSize.large;

  bool operator >(ScreenSize other) => breakpoint > other.breakpoint;

  bool operator <(ScreenSize other) => breakpoint < other.breakpoint;

  bool operator >=(ScreenSize other) => breakpoint >= other.breakpoint;

  bool operator <=(ScreenSize other) => breakpoint <= other.breakpoint;

  bool get isSecondarySideBarExpandedByDefault => ![
    ScreenSize.small,
    ScreenSize.normal,
    ScreenSize.large,
  ].contains(this);
}
