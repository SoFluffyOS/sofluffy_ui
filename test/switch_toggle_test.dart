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

  testWidgets(
    'closing during tap delay does not emit a change after disposal',
    (tester) async {
      final changes = <bool>[];
      await tester.pumpWidget(
        app(SwitchToggle(value: false, onChanged: changes.add)),
      );
      await tester.tap(find.byType(SwitchToggle));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 300));
      expect(changes, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('rebuilding a rejected change restores the value for retry', (
    tester,
  ) async {
    final rebuild = ValueNotifier<int>(0);
    addTearDown(rebuild.dispose);
    final changes = <bool>[];
    await tester.pumpWidget(
      app(
        ValueListenableBuilder<int>(
          valueListenable: rebuild,
          builder: (_, _, _) =>
              SwitchToggle(value: false, onChanged: changes.add),
        ),
      ),
    );
    await tester.tap(find.byType(SwitchToggle));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    expect(changes, [true]);
    rebuild.value++;
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchToggle));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    expect(changes, [true, true]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('accepted parent changes still toggle on and off', (
    tester,
  ) async {
    final value = ValueNotifier<bool>(false);
    addTearDown(value.dispose);
    final changes = <bool>[];
    await tester.pumpWidget(
      app(
        ValueListenableBuilder<bool>(
          valueListenable: value,
          builder: (_, current, _) => SwitchToggle(
            value: current,
            onChanged: (next) {
              changes.add(next);
              value.value = next;
            },
          ),
        ),
      ),
    );
    for (final expected in [true, false]) {
      await tester.tap(find.byType(SwitchToggle));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(value.value, expected);
      expect(
        tester.widget<SwitchToggle>(find.byType(SwitchToggle)).value,
        expected,
      );
    }
    expect(changes, [true, false]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'compact is smaller on desktop and still toggles',
    (
      tester,
    ) async {
      final changes = <bool>[];
      await tester.pumpWidget(
        app(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchToggle(
                key: const ValueKey('regular'),
                value: false,
                onChanged: (_) {},
              ),
              SwitchToggle(
                key: const ValueKey('compact'),
                value: false,
                size: SwitchToggleSize.compact,
                onChanged: changes.add,
              ),
            ],
          ),
        ),
      );

      final regular = tester.getSize(find.byKey(const ValueKey('regular')));
      final compact = tester.getSize(find.byKey(const ValueKey('compact')));
      expect(compact.width, lessThan(regular.width));
      expect(compact.height, lessThan(regular.height));

      await tester.tap(find.byKey(const ValueKey('compact')));
      await tester.pumpAndSettle();
      expect(changes, [true]);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );

  testWidgets(
    'compact keeps the regular size on touch platforms',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchToggle(
                key: const ValueKey('regular'),
                value: false,
                onChanged: (_) {},
              ),
              SwitchToggle(
                key: const ValueKey('compact'),
                value: false,
                size: SwitchToggleSize.compact,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const ValueKey('compact'))),
        tester.getSize(find.byKey(const ValueKey('regular'))),
      );
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  for (final size in SwitchToggleSize.values) {
    testWidgets(
      'a ${size.name} switch moves as quickly as other toggles',
      (tester) async {
        await tester.pumpWidget(
          app(SwitchToggle(value: false, size: size, onChanged: (_) {})),
        );
        await tester.tap(find.byType(SwitchToggle));
        // Its tap delay, then FluffyDurations.toggle.
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump(FluffyDurations.toggle);
        await tester.pump(const Duration(milliseconds: 50));

        expect(tester.hasRunningAnimations, isFalse);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.macOS),
    );
  }
}
