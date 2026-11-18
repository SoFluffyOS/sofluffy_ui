import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  Widget app(Widget child) => FluffyTheme(
    data: FluffyThemeData.fallback(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [OverlayEntry(builder: (_) => Center(child: child))],
      ),
    ),
  );

  testWidgets('opens on tap and runs the picked entry', (tester) async {
    final picked = <String>[];
    await tester.pumpWidget(
      app(
        MenuButton(
          icon: const IconData(0x2026),
          tooltip: 'More',
          entries: [
            MenuEntry(label: 'Settings', onSelected: () => picked.add('a')),
            MenuEntry(
              label: 'Quit',
              startsGroup: true,
              onSelected: () => picked.add('b'),
            ),
          ],
        ),
      ),
    );
    expect(find.text('Settings'), findsNothing);

    await tester.tap(find.byType(MenuButton));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Quit'));
    await tester.pumpAndSettle();
    expect(picked, ['b']);
    expect(find.text('Quit'), findsNothing);
  });

  testWidgets('closes on a tap outside without picking', (tester) async {
    final picked = <String>[];
    await tester.pumpWidget(
      app(
        MenuButton(
          icon: const IconData(0x2026),
          tooltip: 'More',
          entries: [
            MenuEntry(label: 'Settings', onSelected: () => picked.add('a')),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(MenuButton));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsNothing);
    expect(picked, isEmpty);
  });
}
