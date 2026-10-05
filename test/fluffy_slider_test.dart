import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  for (final direction in TextDirection.values) {
    testWidgets('pointer positions and thumb agree in $direction', (
      tester,
    ) async {
      var value = 0.0;
      await tester.pumpWidget(
        _app(
          direction,
          (rebuild) => FluffySlider(
            value: value,
            min: -1,
            max: 1,
            onChanged: (next) => rebuild(() => value = next),
          ),
        ),
      );
      final bounds = tester.getRect(find.byType(FluffySlider));
      final filledTrack = tester.getRect(
        find.descendant(
          of: find.byType(FluffySlider),
          matching: find.byWidgetPredicate((widget) {
            if (widget is! Container) return false;
            if (widget.decoration case BoxDecoration(color: final color)) {
              return color == FluffyThemeData.fallback().colors.primary;
            }
            return false;
          }),
        ),
      );
      expect(filledTrack.width, (bounds.width - Spacing.d16) / 2);
      expect(filledTrack.left, switch (direction) {
        TextDirection.ltr => bounds.left + Spacing.d8,
        TextDirection.rtl => bounds.center.dx,
      });
      await tester.tapAt(Offset(bounds.left + Spacing.d8, bounds.center.dy));
      await tester.pumpAndSettle();
      expect(value, switch (direction) {
        TextDirection.ltr => -1,
        TextDirection.rtl => 1,
      });
      expect(
        tester.getCenter(find.byType(AnimatedScale)).dx,
        bounds.left + Spacing.d8,
      );
      await tester.tapAt(Offset(bounds.right - Spacing.d8, bounds.center.dy));
      await tester.pumpAndSettle();
      expect(value, switch (direction) {
        TextDirection.ltr => 1,
        TextDirection.rtl => -1,
      });
      expect(
        tester.getCenter(find.byType(AnimatedScale)).dx,
        bounds.right - Spacing.d8,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'arrow keys follow direction and respect divisions in $direction',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        var value = 0.5;
        await tester.pumpWidget(
          _app(
            direction,
            (rebuild) => FluffySlider(
              value: value,
              divisions: 4,
              focusNode: focusNode,
              onChanged: (next) => rebuild(() => value = next),
            ),
          ),
        );
        focusNode.requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
        expect(value, switch (direction) {
          TextDirection.ltr => 0.75,
          TextDirection.rtl => 0.25,
        });
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pump();
        expect(value, 0.5);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        expect(value, 0.75);
        for (var step = 0; step < 4; step++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        }
        await tester.pump();
        expect(value, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'semantic actions expose divided values and borrowed focus survives unmount',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        var value = 0.5;
        await tester.pumpWidget(
          _app(
            TextDirection.ltr,
            (rebuild) => FluffySlider(
              value: value,
              divisions: 4,
              focusNode: focusNode,
              onChanged: (next) => rebuild(() => value = next),
            ),
          ),
        );
        final node = tester.getSemantics(
          find.descendant(
            of: find.byType(FluffySlider),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics && widget.properties.slider == true,
            ),
          ),
        );
        final data = node.getSemanticsData();
        expect(data.value, '50%');
        expect(data.increasedValue, '75%');
        expect(data.decreasedValue, '25%');
        node.owner?.performAction(node.id, SemanticsAction.increase);
        await tester.pump();
        expect(value, 0.75);
        await tester.pumpWidget(
          _app(
            TextDirection.ltr,
            (_) => Focus(
              focusNode: focusNode,
              child: const Text('borrowed focus'),
            ),
          ),
        );
        focusNode.requestFocus();
        await tester.pump();
        expect(focusNode.hasFocus, isTrue);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
}

Widget _app(TextDirection direction, Widget Function(StateSetter) builder) =>
    WidgetsApp(
      color: const Color(0xff000000),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      builder: (context, child) => FluffyTheme(
        data: FluffyThemeData.fallback(),
        child: child ?? const SizedBox.shrink(),
      ),
      home: Directionality(
        textDirection: direction,
        child: Center(
          child: SizedBox(
            width: Spacing.d200,
            child: StatefulBuilder(
              builder: (context, rebuild) => builder(rebuild),
            ),
          ),
        ),
      ),
    );
