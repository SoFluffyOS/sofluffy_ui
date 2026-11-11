import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Where [FluffyShimmer]'s highlight is on a box of [size], [progress] of
/// the way through a sweep: a band slanting [angle] down from the top-left,
/// that starts wholly before the box and ends wholly past it, so the loop
/// never shows a jump, on a long line as on a square.
@immutable
class ShimmerBand {
  ShimmerBand(this.size, double progress) : progress = progress.clamp(0.0, 1.0);

  final Size size;
  final double progress;

  /// How far the band slants from the horizontal.
  static const angle = 25 * math.pi / 180;

  /// The way the band sweeps, a unit vector.
  static final direction = Offset(math.cos(angle), math.sin(angle));

  /// How far the box reaches along [direction], from its top-left corner,
  /// the nearest, to its bottom-right, the farthest.
  double get reach => size.width * direction.dx + size.height * direction.dy;

  /// The band's width along [direction]: half the box's reach.
  double get width => reach / 2;

  /// Where the band begins along [direction]: a band's width before the
  /// box at the start, the box's far corner at the end.
  double get start => -width + (reach + width) * progress;

  /// Where the gradient begins and ends in the box, slanting at [angle]
  /// whatever the box's aspect ratio, before [slide] moves it.
  (Alignment, Alignment) get ends {
    final across = direction * width;

    return (
      Alignment.topLeft,
      Alignment(
        -1 + 2 * across.dx / size.width,
        -1 + 2 * across.dy / size.height,
      ),
    );
  }

  /// How far the gradient moves from the box's top-left corner.
  Offset get slide => direction * start;
}
