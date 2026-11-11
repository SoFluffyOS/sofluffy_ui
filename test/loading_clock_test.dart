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
      LoadingClock.instance.addListener(count);

      async.elapse(const Duration(milliseconds: 40));
      async.elapseBlocking(const Duration(milliseconds: 500));

      expect(steps, 1);
      expect(LoadingClock.instance.value, closeTo(0.54, 0.001));
      LoadingClock.instance.removeListener(count);
    });
  });

  testWidgets('stands still while the window draws no frames', (
    tester,
  ) async {
    await tester.pumpWidget(app(const FluffySpinner()));
    await tester.pump(const Duration(seconds: 1));
    final shown = LoadingClock.instance.value;

    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump(const Duration(seconds: 5));
    final hidden = LoadingClock.instance.value;
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    expect(hidden - shown, lessThan(0.1));
  });

  testWidgets('runs only while something moves with it', (tester) async {
    await tester.pumpWidget(app(const FluffySpinner()));
    expect(LoadingClock.instance.isRunning, isTrue);

    await tester.pumpWidget(app(const FluffySpinner(value: 0.5)));
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
