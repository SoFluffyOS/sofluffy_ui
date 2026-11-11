import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  Widget app(Widget child) => FluffyTheme(
    data: FluffyThemeData.fallback(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );

  testWidgets('steps at its own rate, not every frame', (tester) async {
    await tester.pumpWidget(app(const FluffySpinner()));

    var steps = 0;
    void count() => steps++;
    LoadingClock.instance.addListener(count);
    await tester.pump(const Duration(seconds: 1));
    LoadingClock.instance.removeListener(count);

    expect(steps, LoadingClock.stepsPerSecond);
    expect(LoadingClock.instance.value, closeTo(1, 0.05));
  });

  test('follows the time that passed when a step comes late', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    fakeAsync((async) {
      var steps = 0;
      void count() => steps++;
      final start = LoadingClock.instance.value;
      LoadingClock.instance.addListener(count);

      async.elapse(const Duration(milliseconds: 40));
      async.elapseBlocking(const Duration(milliseconds: 500));

      expect(steps, 1);
      expect(LoadingClock.instance.value - start, closeTo(0.54, 0.001));
      LoadingClock.instance.removeListener(count);
    });
  });

  testWidgets('draws nothing while the window draws no frames', (
    tester,
  ) async {
    await tester.pumpWidget(app(const FluffySpinner()));
    var steps = 0;
    void count() => steps++;
    LoadingClock.instance.addListener(count);

    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump(const Duration(seconds: 1));
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    LoadingClock.instance.removeListener(count);

    expect(steps, 0);
  });

  testWidgets('a rebuild that swaps the painter carries on the turn', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const FluffySpinner(color: Color(0xFF000000))),
    );
    await tester.pump(const Duration(milliseconds: 500));
    final before = LoadingClock.instance.value;

    await tester.pumpWidget(
      app(const FluffySpinner(color: Color(0xFFFFFFFF))),
    );

    expect(LoadingClock.instance.isRunning, isTrue);
    expect(LoadingClock.instance.value, greaterThanOrEqualTo(before));
    await tester.pump(const Duration(milliseconds: 500));
    expect(LoadingClock.instance.value, closeTo(before + 0.5, 0.05));
  });

  test('a listener added again within a step carries on the time', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    fakeAsync((async) {
      void listen() {}
      LoadingClock.instance.addListener(listen);
      async.elapse(const Duration(milliseconds: 500));
      final before = LoadingClock.instance.value;

      LoadingClock.instance.removeListener(listen);
      async.elapse(const Duration(milliseconds: 10));
      LoadingClock.instance.addListener(listen);

      expect(LoadingClock.instance.value, closeTo(before + 0.01, 0.001));
      LoadingClock.instance.removeListener(listen);
    });
  });

  testWidgets('runs only while something moves with it', (tester) async {
    await tester.pumpWidget(app(const FluffySpinner()));
    expect(LoadingClock.instance.isRunning, isTrue);

    await tester.pumpWidget(app(const FluffySpinner(value: 0.5)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(LoadingClock.instance.isRunning, isFalse);
  });

  testWidgets('stands still where tickers are off', (tester) async {
    await tester.pumpWidget(
      app(const TickerMode(enabled: false, child: FluffySpinner())),
    );

    expect(LoadingClock.instance.isRunning, isFalse);
  });

  testWidgets('a shimmer fills its box and keeps the clock running', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const SizedBox(width: 80, height: 10, child: LoadingBox())),
    );

    expect(tester.getSize(find.byType(FluffyShimmer)), const Size(80, 10));
    expect(LoadingClock.instance.isRunning, isTrue);
  });
}
