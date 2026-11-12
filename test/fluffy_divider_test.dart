import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  Widget app(Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: FluffyTheme(
      data: FluffyThemeData.fallback(),
      child: Center(child: SizedBox(width: 200, height: 100, child: child)),
    ),
  );

  Rect lineRect(WidgetTester tester) => tester.getRect(find.byType(ColoredBox));

  testWidgets('a horizontal line is centered in its extent', (tester) async {
    await tester.pumpWidget(
      app(
        const Align(
          alignment: Alignment.topLeft,
          child: FluffyDivider(
            extent: 20,
            thickness: 2,
            indent: 8,
            endIndent: 4,
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(FluffyDivider)), const Size(200, 20));
    final line = lineRect(tester);
    final divider = tester.getRect(find.byType(FluffyDivider));
    expect(line.height, 2);
    expect(line.top - divider.top, 9);
    expect(line.left - divider.left, 8);
    expect(divider.right - line.right, 4);
  });

  testWidgets('a vertical line runs down its parent', (tester) async {
    await tester.pumpWidget(
      app(
        const Align(
          alignment: Alignment.topLeft,
          child: FluffyDivider.vertical(extent: 10, indent: 6),
        ),
      ),
    );

    expect(tester.getSize(find.byType(FluffyDivider)), const Size(10, 100));
    final line = lineRect(tester);
    expect(line.width, Spacing.d1);
    expect(line.height, 94);
  });

  testWidgets('takes the theme color unless given one', (tester) async {
    await tester.pumpWidget(app(const FluffyDivider()));
    final context = tester.element(find.byType(FluffyDivider));
    expect(
      tester.widget<ColoredBox>(find.byType(ColoredBox)).color,
      FluffyDivider.defaultColor(context),
    );

    const red = Color(0xFFFF0000);
    await tester.pumpWidget(app(const FluffyDivider(color: red)));
    expect(tester.widget<ColoredBox>(find.byType(ColoredBox)).color, red);
  });
}
