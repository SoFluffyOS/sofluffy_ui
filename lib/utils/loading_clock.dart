import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// The one clock every spinner, progress bar, shimmer and pulse moves to:
/// seconds on one stopwatch that never stops, drawn [stepsPerSecond] times
/// a second.
///
/// A [Ticker] asks for a frame on every vsync, 120 a second on a ProMotion
/// display, and each frame costs the whole pipeline however small the
/// change. Stepping on a timer draws a quarter of those frames, and sharing
/// it draws every loading effect in the same ones, all at the same phase.
///
/// The time is measured, not counted in steps, so a late step on a busy
/// machine never slows the effects down, and an effect rebuilt or shown
/// again carries on where every other one is. The timer runs only while
/// something listens, and draws nothing while the window draws no frames.
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
  Stopwatch? _stopwatch;
  Clock? _stopwatchClock;

  /// Whether the clock steps now. When its last listener goes during a
  /// frame, as when a rebuild swaps a painter for another, it stops only
  /// once the frame is done, if nothing listens again by then.
  bool get isRunning => _timer != null;

  @override
  double get value =>
      _elapsed.elapsedMicroseconds / Duration.microsecondsPerSecond;

  @override
  AnimationStatus get status => AnimationStatus.forward;

  /// The one stopwatch, made on first use. Only a different [clock], as each
  /// test's fake time brings, makes another.
  Stopwatch get _elapsed {
    final current = clock;
    final stopwatch = _stopwatch;
    if (stopwatch != null && identical(_stopwatchClock, current)) {
      return stopwatch;
    }

    _stopwatchClock = current;
    return _stopwatch = current.stopwatch()..start();
  }

  @override
  void didStartListening() {
    _timer ??= Timer.periodic(_step, _onStep);
  }

  @override
  void didStopListening() {
    final scheduler = SchedulerBinding.instance;
    final inFrame = scheduler.schedulerPhase != SchedulerPhase.idle;
    if (!inFrame) {
      _stopUnlessListened();
      return;
    }

    scheduler.addPostFrameCallback((_) => _stopUnlessListened());
  }

  void _stopUnlessListened() {
    if (isListening) {
      return;
    }

    _timer?.cancel();
    _timer = null;
  }

  void _onStep(Timer timer) {
    if (!isListening) {
      _stopUnlessListened();
      return;
    }

    final windowShows = SchedulerBinding.instance.framesEnabled;
    if (!windowShows) {
      return;
    }

    notifyListeners();
  }
}
