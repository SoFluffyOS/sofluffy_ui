import 'package:design_system/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
          home: Center(
            child: Tappable(
              key: const ValueKey('target'),
              onDoubleTap: () => doubleTapCount++,
              child: const SizedBox(width: 100, height: 40),
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
}

Future<void> _pumpTappable(
  WidgetTester tester, {
  required VoidCallback onTap,
  required VoidCallback onDoubleTap,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Center(
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
  );
}
