import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/themes/app_theme_data.dart';
import 'package:sofluffy_ui/themes/spacing.dart';

/// How interactive components size themselves: for a mouse, or for a
/// finger.
///
/// Without a [FluffyDensityScope], phones and tablets get [touch] and
/// desktops [pointer].
enum FluffyDensity {
  /// A mouse or a trackpad: compact components, and targets are what they
  /// show.
  pointer,

  /// A finger: components draw larger, and every target is at least
  /// [minTarget] square.
  touch,

  /// A finger on a dense screen, such as an editor: components draw as
  /// compact as for [pointer], and only the area a tap lands on grows to
  /// [minTarget].
  compactTouch;

  /// The density for [platform] when no [FluffyDensityScope] sets one.
  static FluffyDensity forPlatform(TargetPlatform platform) =>
      switch (platform) {
        TargetPlatform.android ||
        TargetPlatform.iOS ||
        TargetPlatform.fuchsia => FluffyDensity.touch,
        TargetPlatform.macOS ||
        TargetPlatform.windows ||
        TargetPlatform.linux => FluffyDensity.pointer,
      };

  /// The smallest side of a target, zero when targets aren't grown.
  double get minTarget => switch (this) {
    FluffyDensity.pointer => 0,
    FluffyDensity.touch || FluffyDensity.compactTouch => Spacing.d48,
  };

  /// [size], or [minTarget] when that's bigger: the extent of a row or a
  /// bar that holds targets, such as a tree row or a tab strip.
  double extent(double size) => math.max(size, minTarget);

  /// Whether a finger uses the components.
  bool get isTouch => this != FluffyDensity.pointer;

  /// Whether components draw their larger, finger-sized look: bigger text,
  /// padding, check boxes and switches.
  bool get drawsLarge => this == FluffyDensity.touch;
}

/// Sets the [FluffyDensity] of the components below it. Without one, the
/// density follows the platform, as [FluffyDensity.forPlatform] says.
class FluffyDensityScope extends InheritedWidget {
  const FluffyDensityScope({
    super.key,
    required this.density,
    required super.child,
  });

  final FluffyDensity density;

  static FluffyDensity of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<FluffyDensityScope>()
          ?.density ??
      FluffyDensity.forPlatform(context.fluffyTargetPlatform);

  @override
  bool updateShouldNotify(FluffyDensityScope oldWidget) =>
      density != oldWidget.density;
}

extension FluffyDensityContext on BuildContext {
  /// The [FluffyDensity] the nearest [FluffyDensityScope] sets, or the
  /// platform's.
  FluffyDensity get fluffyDensity => FluffyDensityScope.of(this);
}
