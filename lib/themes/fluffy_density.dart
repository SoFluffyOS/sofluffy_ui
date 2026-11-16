import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/themes/spacing.dart';

/// How big the targets of interactive components are: the size of what
/// they show for a mouse, at least [Spacing.d48] square for a finger.
///
/// Visuals stay the same in both: only the area a tap lands on grows.
enum FluffyDensity {
  /// A mouse or a trackpad: targets are what they show.
  pointer,

  /// A finger: every target is at least [minTarget] square.
  touch;

  /// The smallest side of a target, zero when targets aren't grown.
  double get minTarget => switch (this) {
    FluffyDensity.pointer => 0,
    FluffyDensity.touch => Spacing.d48,
  };

  /// [size], or [minTarget] when that's bigger: the extent of a row or a
  /// bar that holds targets, such as a tree row or a tab strip.
  double extent(double size) => math.max(size, minTarget);

  bool get isTouch => this == FluffyDensity.touch;
}

/// Sets the [FluffyDensity] of the components below it. Without one, the
/// density is [FluffyDensity.pointer].
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
      FluffyDensity.pointer;

  @override
  bool updateShouldNotify(FluffyDensityScope oldWidget) =>
      density != oldWidget.density;
}

extension FluffyDensityContext on BuildContext {
  /// The [FluffyDensity] the nearest [FluffyDensityScope] sets.
  FluffyDensity get fluffyDensity => FluffyDensityScope.of(this);
}
