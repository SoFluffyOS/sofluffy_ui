import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  const longLabel =
      'A label much longer than the button has room for, as a translation';

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFF000000),
      builder: (_, _) => FluffyTheme(
        data: FluffyThemeData.fallback(),
        child: Center(child: child),
      ),
    ),
  );

  testWidgets('a long label shortens in a narrow button', (tester) async {
    await pump(
      tester,
      SizedBox(
        width: 120,
        child: Button(
          variant: ButtonVariant.primary,
          label: longLabel,
          onPressed: () {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(Button)).width, lessThanOrEqualTo(120));
  });

  testWidgets('a button in an unbounded row keeps its whole label', (
    tester,
  ) async {
    await pump(
      tester,
      SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Button(
              variant: ButtonVariant.primary,
              label: longLabel,
              mainAxisSize: MainAxisSize.min,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(Button)).width, greaterThan(200));
  });

  testWidgets('a button reports its intrinsic size', (tester) async {
    await pump(
      tester,
      IntrinsicHeight(
        child: IntrinsicWidth(
          child: Button(
            variant: ButtonVariant.primary,
            label: longLabel,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
