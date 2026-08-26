import 'package:flutter/widgets.dart';

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

  static double get d200 => d4 * 50;

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

  static Widget get h6 => horizontal(d6);

  static Widget get h8 => horizontal(d8);

  static Widget get h12 => horizontal(d12);

  static Widget get h16 => horizontal(d16);

  static Widget get h24 => horizontal(d24);

  static Widget get h32 => horizontal(d32);

  static Widget get h48 => horizontal(d48);

  static Widget get v4 => vertical(d4);

  static Widget get v6 => vertical(d6);

  static Widget get v8 => vertical(d8);

  static Widget get v12 => vertical(d12);

  static Widget get v16 => vertical(d16);

  static Widget get v24 => vertical(d24);

  static Widget get v32 => vertical(d32);

  static Widget get v48 => vertical(d48);

  static const BorderRadius r4 = BorderRadius.all(
    Radius.circular(4.0),
  );
  static const BorderRadius r6 = BorderRadius.all(
    Radius.circular(6.0),
  );
  static const BorderRadius r8 = BorderRadius.all(
    Radius.circular(8.0),
  );
  static const BorderRadius r10 = BorderRadius.all(
    Radius.circular(10.0),
  );
  static const BorderRadius r12 = BorderRadius.all(
    Radius.circular(12.0),
  );
  static const BorderRadius r16 = BorderRadius.all(
    Radius.circular(16.0),
  );
  static const BorderRadius r24 = BorderRadius.all(
    Radius.circular(24.0),
  );
}
