import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  testWidgets('dispatches the first tap immediately and the second as double', (
    tester,
  ) async {
    var tapCount = 0;
    var doubleTapCount = 0;
    await _pumpTappable(
      tester,
      onTap: () => tapCount++,
      onDoubleTap: () => doubleTapCount++,
    );

    final target = find.byKey(const ValueKey('target'));
    await tester.tap(target);

    expect(tapCount, 1);
    expect(doubleTapCount, 0);

    await tester.tap(target);

    expect(tapCount, 1);
    expect(doubleTapCount, 1);
  });

  testWidgets('dispatches two taps outside the double-tap window', (
    tester,
  ) async {
    var tapCount = 0;
    var doubleTapCount = 0;
    await _pumpTappable(
      tester,
      onTap: () => tapCount++,
      onDoubleTap: () => doubleTapCount++,
    );

    final target = find.byKey(const ValueKey('target'));
    await tester.tap(target);
    final secondTap = await tester.createGesture();
    await secondTap.down(
      tester.getCenter(target),
      timeStamp: kDoubleTapTimeout + const Duration(milliseconds: 1),
    );
    await secondTap.up(
      timeStamp: kDoubleTapTimeout + const Duration(milliseconds: 2),
    );

    expect(tapCount, 2);
    expect(doubleTapCount, 0);
  });

  testWidgets(
    'dispatches double tap when widget rebuilds with new closure between taps',
    (tester) async {
      var doubleTapCount = 0;

      Widget buildWidget() {
        return MaterialApp(
          home: FluffyTheme(
            data: FluffyThemeData.fallback(),
            child: Center(
              child: Tappable(
                key: const ValueKey('target'),
                onDoubleTap: () => doubleTapCount++,
                child: const SizedBox(width: 100, height: 40),
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildWidget());
      final target = find.byKey(const ValueKey('target'));
      await tester.tap(target);

      // Rebuild with new closure instance
      await tester.pumpWidget(buildWidget());

      await tester.tap(target);
      expect(doubleTapCount, 1);
    },
  );

  testWidgets('shows a styled tooltip after hovering', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: Center(
            child: Tappable(
              key: const ValueKey('tooltip-target'),
              tooltip: 'Open in editor',
              onTap: () {},
              child: const SizedBox(width: 100, height: 40),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(
      tester.getCenter(find.byKey(const ValueKey('tooltip-target'))),
    );
    await tester.pump(FluffyDurations.tooltip);

    expect(find.text('Open in editor'), findsOneWidget);
    final tooltipDecoration = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<ShapeDecoration>()
        .singleWhere((decoration) => decoration.shadows?.isNotEmpty ?? false);
    final tooltipShape = tooltipDecoration.shape as RoundedSuperellipseBorder;
    expect(tooltipShape.side.color, FluffyThemeData.fallback().colors.neutral3);
    expect(tooltipDecoration.shadows, isNotEmpty);
    final targetBottom = tester
        .getBottomLeft(find.byKey(const ValueKey('tooltip-target')))
        .dy;
    final tooltipTop = tester.getTopLeft(find.text('Open in editor')).dy;
    expect(tooltipTop, greaterThan(targetBottom));
    expect(tooltipTop - targetBottom, lessThanOrEqualTo(Spacing.d16));
  });

  testWidgets('shows the tooltip near and above a lower target', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: Align(
            alignment: const Alignment(0, 0.8),
            child: Tappable(
              key: const ValueKey('lower-tooltip-target'),
              tooltip: 'Stop plugin',
              onTap: () {},
              child: const SizedBox(width: 100, height: 40),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(
      tester.getCenter(find.byKey(const ValueKey('lower-tooltip-target'))),
    );
    await tester.pump(FluffyDurations.tooltip);

    final targetTop = tester
        .getTopLeft(find.byKey(const ValueKey('lower-tooltip-target')))
        .dy;
    final tooltipBottom = tester.getBottomLeft(find.text('Stop plugin')).dy;
    expect(tooltipBottom, lessThan(targetTop));
    expect(targetTop - tooltipBottom, lessThanOrEqualTo(Spacing.d16));
  });

  testWidgets('keeps tooltips inside horizontal window edges', (tester) async {
    Future<void> expectTooltipInside({
      required Alignment alignment,
      required String targetKey,
      required String message,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluffyTheme(
            data: FluffyThemeData.fallback(),
            child: Align(
              alignment: alignment,
              child: Tappable(
                key: ValueKey(targetKey),
                tooltip: message,
                onTap: () {},
                child: SizedBox(
                  width: Spacing.d40,
                  height: Spacing.d40,
                ),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.byKey(ValueKey(targetKey))));
      await tester.pump(FluffyDurations.tooltip);

      final surface = find.byKey(const ValueKey('fluffy-tooltip-surface'));
      final surfaceRect = tester.getRect(surface);
      final windowWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      expect(surfaceRect.left, greaterThanOrEqualTo(Spacing.d8));
      expect(surfaceRect.right, lessThanOrEqualTo(windowWidth - Spacing.d8));
      await gesture.removePointer();
    }

    await expectTooltipInside(
      alignment: Alignment.centerLeft,
      targetKey: 'left-tooltip-target',
      message: 'A wide tooltip near the left window edge',
    );
    await expectTooltipInside(
      alignment: Alignment.centerRight,
      targetKey: 'right-tooltip-target',
      message: 'A wide tooltip near the right window edge',
    );
  });

  testWidgets('keeps long tooltips inside vertical window edges', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 120);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: Center(
            child: Tappable(
              key: const ValueKey('vertical-tooltip-target'),
              tooltip:
                  'A long tooltip that wraps over several lines while the '
                  'available window height is deliberately very small.',
              onTap: () {},
              child: SizedBox(width: Spacing.d40, height: Spacing.d40),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(
      tester.getCenter(
        find.byKey(const ValueKey('vertical-tooltip-target')),
      ),
    );
    await tester.pump(FluffyDurations.tooltip);
    await tester.pump();

    final surfaceRect = tester.getRect(
      find.byKey(const ValueKey('fluffy-tooltip-surface')),
    );
    expect(surfaceRect.top, greaterThanOrEqualTo(Spacing.d8));
    expect(surfaceRect.bottom, lessThanOrEqualTo(120 - Spacing.d8));
  });
}

Future<void> _pumpTappable(
  WidgetTester tester, {
  required VoidCallback onTap,
  required VoidCallback onDoubleTap,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: FluffyTheme(
        data: FluffyThemeData.fallback(),
        child: Center(
          child: Tappable(
            key: const ValueKey('target'),
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            child: const SizedBox(
              width: 100,
              height: 40,
            ),
          ),
        ),
      ),
    ),
  );
}
