import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  Widget app(Widget child) => WidgetsApp(
    color: const Color(0xFF007AFF),
    builder: (_, _) => FluffyTheme(
      data: FluffyThemeData.fallback(),
      child: FocusScope(autofocus: true, child: Center(child: child)),
    ),
  );

  setUp(() {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  testWidgets('an icon-only Tappable is a labelled button', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      app(
        Tappable(
          semanticLabel: 'Add a device',
          onTap: () {},
          child: const SizedBox.square(dimension: 32),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(Tappable)),
      isSemantics(
        label: 'Add a device',
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('a tooltip is the spoken name when there is no label', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      app(
        Tappable(
          tooltip: 'More',
          onTap: () {},
          child: const SizedBox.square(dimension: 32),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.bySemanticsLabel('More')),
      isSemantics(
        label: 'More',
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('a Button with a tooltip says it once', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      app(
        Button(
          variant: ButtonVariant.ghost,
          tooltip: 'Add a device',
          onPressed: () {},
          child: const SizedBox.square(dimension: 16),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Add a device'), findsOneWidget);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Add a device')),
      isSemantics(
        label: 'Add a device',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('a Button is one stop: its text, button, enabled', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      app(
        Button(variant: ButtonVariant.ghost, label: 'Pair', onPressed: () {}),
      ),
    );

    expect(
      tester.getSemantics(find.byType(Button)),
      isSemantics(
        label: 'Pair',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('a row of text asked to be a button is one', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      app(
        Tappable(
          semanticButton: true,
          onTap: () {},
          child: const Text('Notifications'),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(Tappable)),
      isSemantics(
        label: 'Notifications',
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('Tab draws a focus ring around a Button, Enter presses it', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      app(
        Button(
          variant: ButtonVariant.ghost,
          label: 'Pair',
          onPressed: () => presses++,
        ),
      ),
    );
    AnimatedContainer box() => tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(Button),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect(box().foregroundDecoration, isNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(box().foregroundDecoration, isA<ShapeDecoration>());

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(presses, 1);
  });

  testWidgets('a SwitchToggle says whether it is on', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      app(
        SwitchToggle(
          value: true,
          onChanged: (_) {},
          semanticLabel: 'Sync clipboard',
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(SwitchToggle)),
      isSemantics(
        label: 'Sync clipboard',
        hasToggledState: true,
        isToggled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('Space flips a focused SwitchToggle', (tester) async {
    final changes = <bool>[];
    await tester.pumpWidget(
      app(SwitchToggle(value: false, onChanged: changes.add)),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(changes, [true]);
  });
}
