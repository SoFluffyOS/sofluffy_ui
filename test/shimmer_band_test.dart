import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  const boxes = {
    'a skeleton line': Size(240, 12),
    'an avatar': Size(40, 40),
    'a tall column': Size(12, 200),
  };

  for (final MapEntry(key: name, value: size) in boxes.entries) {
    test('the band starts before $name and ends past it', () {
      final first = ShimmerBand(size, 0);
      final last = ShimmerBand(size, 1);

      expect(first.start + first.width, lessThanOrEqualTo(1e-9));
      expect(last.start, greaterThanOrEqualTo(last.reach - 1e-9));
    });

    test('the band slants down to the right across $name', () {
      final band = ShimmerBand(size, 0.5);
      final (begin, end) = band.ends;

      final from = begin.alongSize(size);
      final to = end.alongSize(size);
      final slant = math.atan2(to.dy - from.dy, to.dx - from.dx);

      expect(slant, closeTo(ShimmerBand.angle, 1e-9));
      expect(
        ShimmerBand.angle,
        inInclusiveRange(20 * math.pi / 180, 30 * math.pi / 180),
      );
      expect((to - from).distance, closeTo(band.width, 1e-9));
    });
  }

  test('the band moves along its slant as the sweep goes', () {
    const size = Size(240, 12);
    final quarter = ShimmerBand(size, 0.25);
    final half = ShimmerBand(size, 0.5);

    final moved = half.slide - quarter.slide;
    expect(math.atan2(moved.dy, moved.dx), closeTo(ShimmerBand.angle, 1e-9));
    expect(moved.distance, closeTo(half.start - quarter.start, 1e-9));
  });
}
