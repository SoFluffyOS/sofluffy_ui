import 'package:flutter/widgets.dart';

extension ScreenSizeExt on ScreenSize {
  Widget buildFor({
    Widget Function()? small,
    Widget Function()? normal,
    Widget Function()? large,
    Widget Function()? larger,
    Widget Function()? extraLarge,
  }) {
    // dart format off
    return switch (this) {
      ScreenSize.small => small?.call() ?? normal?.call() ?? large?.call() ?? larger?.call() ?? extraLarge?.call() ?? const SizedBox.shrink(),
      ScreenSize.normal => normal?.call() ?? large?.call() ?? larger?.call() ?? extraLarge?.call() ?? const SizedBox.shrink(),
      ScreenSize.large => large?.call() ?? larger?.call() ?? extraLarge?.call() ?? const SizedBox.shrink(),
      ScreenSize.larger => larger?.call() ?? extraLarge?.call() ?? const SizedBox.shrink(),
      ScreenSize.extraLarge => extraLarge?.call() ?? const SizedBox.shrink(),
    };
    // dart format on
  }
}

class ScreenSizeNotifier extends ChangeNotifier {
  ScreenSize _screenSize = ScreenSize.normal;

  ScreenSize get screenSize => _screenSize;

  void updateScreenSize(ScreenSize screenSize) {
    _screenSize = screenSize;
    notifyListeners();
  }
}

/// Breakpoint according to Material guidelines.
/// Ref: https://m3.material.io/foundations/layout/breakpoints
enum ScreenSize {
  small(0),
  normal(600),
  large(840),
  larger(1200),
  extraLarge(1600);

  final int breakpoint;

  const ScreenSize(this.breakpoint);

  static ScreenSize of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return fromWidth(size.width);
  }

  static ScreenSize fromWidth(double width) {
    if (width < normal.breakpoint) {
      return ScreenSize.small;
    }

    if (width < large.breakpoint) {
      return ScreenSize.normal;
    }

    if (width < larger.breakpoint) {
      return ScreenSize.large;
    }

    if (width < extraLarge.breakpoint) {
      return ScreenSize.larger;
    }

    return ScreenSize.extraLarge;
  }
}

extension ScreenSizeExtension on ScreenSize {
  bool get isHandyDevice => this <= ScreenSize.normal;

  bool get isSmallDevice => this <= ScreenSize.small;

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
