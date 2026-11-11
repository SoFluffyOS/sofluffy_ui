import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// The one clock every spinner, progress bar, shimmer and pulse moves to:
/// seconds since it started, drawn [stepsPerSecond] times a second.
///
/// A [Ticker] asks for a frame on every vsync, 120 a second on a ProMotion
/// display, and each frame costs the whole pipeline however small the
/// change. Stepping on a timer draws a quarter of those frames, and sharing
/// it draws every loading effect in the same ones. It runs only while
/// something listens, and starts again from zero.
///
/// The time is measured, not counted in steps, so a late step on a busy
/// machine never slows the effects down. It stands still while the window
/// draws no frames, so they don't jump when it shows again.
class LoadingClock extends Animation<double>
    with
        AnimationLazyListenerMixin,
        AnimationLocalListenersMixin,
        AnimationLocalStatusListenersMixin {
  LoadingClock._();

  /// The clock the app's loading effects share.
  static final LoadingClock instance = LoadingClock._();

  /// How often loading effects move: smooth enough for a small ring, and a
  /// quarter of a 120 Hz display's frames.
  static const stepsPerSecond = 30;

  static const _step = Duration(microseconds: 1000000 ~/ stepsPerSecond);

  static const _stopped = AlwaysStoppedAnimation<double>(0);

  /// The clock for a loading effect at [context]: [instance], or one that
  /// stands still where tickers are off, such as an offstage route, so a
  /// hidden effect never asks for frames.
  static Animation<double> of(BuildContext context) =>
      switch (TickerMode.valuesOf(context).enabled) {
        true => instance,
        false => _stopped,
      };

  Timer? _timer;
  Stopwatch _elapsed = clock.stopwatch();

  /// Whether the clock steps now: something on screen moves with it.
  bool get isRunning => _timer != null;

  @override
  double get value =>
      _elapsed.elapsedMicroseconds / Duration.microsecondsPerSecond;

  @override
  AnimationStatus get status => AnimationStatus.forward;

  @override
  void didStartListening() {
    _elapsed = clock.stopwatch()..start();
    _timer = Timer.periodic(_step, _onStep);
  }

  @override
  void didStopListening() {
    _timer?.cancel();
    _timer = null;
    _elapsed.stop();
  }

  void _onStep(Timer timer) {
    final windowShows = SchedulerBinding.instance.framesEnabled;
    if (!windowShows) {
      _elapsed.stop();
      return;
    }

    _elapsed.start();
    notifyListeners();
  }
}
