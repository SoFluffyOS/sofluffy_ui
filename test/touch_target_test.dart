import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  Widget app(Widget child, {FluffyDensity? density}) {
    final themed = Directionality(
      textDirection: TextDirection.ltr,
      child: FluffyTheme(
        data: FluffyThemeData.fallback(),
        child: Center(child: child),
      ),
    );
    if (density == null) {
      return themed;
    }

    return FluffyDensityScope(density: density, child: themed);
  }

  Widget icon({VoidCallback? onTap}) => Tappable(
    key: const Key('target'),
    onTap: onTap,
    child: const SizedBox.square(key: Key('icon'), dimension: 16),
  );

  testWidgets('a pointer keeps targets the size of what they show', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(icon(onTap: () {}), density: FluffyDensity.pointer),
    );

    expect(tester.getSize(find.byKey(const Key('target'))), const Size(16, 16));
  });

  testWidgets('a finger gets a 48 square around a small target, which '
      'still draws at its own size', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      app(icon(onTap: () => taps++), density: FluffyDensity.compactTouch),
    );

    final target = tester.getRect(find.byKey(const Key('target')));
    expect(target.size, Size.square(Spacing.d48));
    expect(tester.getSize(find.byKey(const Key('icon'))), const Size(16, 16));
    expect(
      tester.getCenter(find.byKey(const Key('icon'))),
      target.center,
    );

    await tester.tapAt(target.topLeft + const Offset(2, 2));
    expect(taps, 1, reason: 'a tap in the margin reaches the target');
  });

  testWidgets('a target that does nothing is not grown', (tester) async {
    await tester.pumpWidget(app(icon(), density: FluffyDensity.compactTouch));

    expect(tester.getSize(find.byKey(const Key('target'))), const Size(16, 16));
  });

  testWidgets('a parent that sizes its child tightly keeps its size', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        SizedBox(height: 22, width: 100, child: icon(onTap: () {})),
        density: FluffyDensity.compactTouch,
      ),
    );

    expect(
      tester.getSize(find.byKey(const Key('target'))),
      const Size(100, 22),
    );
  });

  testWidgets('a switch looks the same for a finger on a dense screen and '
      'takes taps around it', (tester) async {
    var value = false;
    Widget toggle() => SwitchToggle(
      key: const Key('switch'),
      value: value,
      onChanged: (newValue) => value = newValue,
    );

    await tester.pumpWidget(app(toggle(), density: FluffyDensity.pointer));
    final pointerTrack = tester.getSize(find.byType(AnimatedContainer).first);

    await tester.pumpWidget(app(toggle(), density: FluffyDensity.compactTouch));
    final touchTrack = tester.getSize(find.byType(AnimatedContainer).first);
    final target = tester.getRect(find.byKey(const Key('switch')));

    expect(touchTrack, pointerTrack);
    expect(target.height, greaterThanOrEqualTo(Spacing.d48));
    expect(target.width, greaterThanOrEqualTo(Spacing.d48));

    await tester.tapAt(target.bottomCenter - const Offset(0, 2));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    expect(value, isTrue);
  });

  testWidgets('a finger gets the larger look and a 48 target', (
    tester,
  ) async {
    Widget toggle() => SwitchToggle(
      key: const Key('switch'),
      value: false,
      onChanged: (_) {},
    );

    await tester.pumpWidget(app(toggle(), density: FluffyDensity.pointer));
    final pointerTrack = tester.getSize(find.byType(AnimatedContainer).first);

    await tester.pumpWidget(app(toggle(), density: FluffyDensity.touch));
    final touchTrack = tester.getSize(find.byType(AnimatedContainer).first);
    final target = tester.getRect(find.byKey(const Key('switch')));

    expect(touchTrack.width, greaterThan(pointerTrack.width));
    expect(target.height, greaterThanOrEqualTo(Spacing.d48));
  });

  for (final (platform, density) in [
    (TargetPlatform.android, FluffyDensity.touch),
    (TargetPlatform.iOS, FluffyDensity.touch),
    (TargetPlatform.macOS, FluffyDensity.pointer),
    (TargetPlatform.windows, FluffyDensity.pointer),
    (TargetPlatform.linux, FluffyDensity.pointer),
  ]) {
    testWidgets('without a scope, ${platform.name} gets ${density.name}', (
      tester,
    ) async {
      late FluffyDensity found;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) {
              found = context.fluffyDensity;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(found, density);
    }, variant: TargetPlatformVariant.only(platform));
  }

  test('extents grow only for a finger', () {
    expect(FluffyDensity.pointer.extent(22), 22);
    expect(FluffyDensity.touch.extent(22), Spacing.d48);
    expect(FluffyDensity.compactTouch.extent(22), Spacing.d48);
    expect(FluffyDensity.compactTouch.extent(60), 60);
  });
}
