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
}
