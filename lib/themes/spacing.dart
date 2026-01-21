import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';

class Spacing {
  static void setBase(double value) {
    d4 = value;
  }

  static double d4 = 4.0;

  static double get d0 => d4 * 0.125;

  static double get d1 => d4 * 0.25;

  static double get d2 => d4 * 0.5;

  static double get d3 => d4 * 0.75;

  static double get d6 => d4 * 1.5;

  static double get d8 => d4 * 2;

  static double get d10 => d4 * 2.5;

  static double get d12 => d4 * 3;

  static double get d14 => d4 * 3.5;

  static double get d16 => d4 * 4;

  static double get d18 => d4 * 4.5;

  static double get d20 => d4 * 5;

  static double get d24 => d4 * 6;

  static double get d28 => d4 * 7;

  static double get d32 => d4 * 8;

  static double get d36 => d4 * 9;

  static double get d40 => d4 * 10;

  static double get d44 => d4 * 11;

  static double get d48 => d4 * 12;

  static double get d52 => d4 * 13;

  static double get d56 => d4 * 14;

  static double get d60 => d4 * 15;

  static double get d64 => d4 * 16;

  static double get d68 => d4 * 17;

  static double get d72 => d4 * 18;

  static double get d76 => d4 * 19;

  static double get d80 => d4 * 20;

  static double get d84 => d4 * 21;

  static double get d96 => d4 * 24;

  static double get d280 => d4 * 70;

  static double get d320 => d4 * 80;

  static double get d360 => d4 * 90;

  static Widget vertical(double value) {
    return SizedBox(height: value);
  }

  static Widget horizontal(double value) {
    return SizedBox(width: value);
  }

  static Widget all(double value) {
    return SizedBox(width: value, height: value);
  }

  static Widget get h4 => horizontal(d4);

  static Widget get h8 => horizontal(d8);

  static Widget get h12 => horizontal(d12);

  static Widget get h16 => horizontal(d16);

  static Widget get h24 => horizontal(d24);

  static Widget get v4 => vertical(d4);

  static Widget get v8 => vertical(d8);

  static Widget get v16 => vertical(d16);

  static Widget get v24 => vertical(d24);

  static BorderRadius get r12 => BorderRadius.circular(12.0);

  static SmoothBorderRadius get smoothR8 => const SmoothBorderRadius.all(
    SmoothRadius(
      cornerRadius: 8.0,
      cornerSmoothing: 1.0,
    ),
  );

  static SmoothBorderRadius get smoothR10 => const SmoothBorderRadius.all(
    SmoothRadius(
      cornerRadius: 10.0,
      cornerSmoothing: 1.0,
    ),
  );

  static SmoothBorderRadius get smoothR12 => const SmoothBorderRadius.all(
    SmoothRadius(
      cornerRadius: 12.0,
      cornerSmoothing: 1.0,
    ),
  );

  static SmoothBorderRadius get smoothR16 => const SmoothBorderRadius.all(
    SmoothRadius(
      cornerRadius: 16.0,
      cornerSmoothing: 1.0,
    ),
  );

  static SmoothBorderRadius get smoothR24 => const SmoothBorderRadius.all(
    SmoothRadius(
      cornerRadius: 24.0,
      cornerSmoothing: 1.0,
    ),
  );
}
