import 'package:flutter/gestures.dart';
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

  testWidgets('with a label it is a button that says so', (tester) async {
    await tester.pumpWidget(
      app(
        MenuButton(
          icon: const IconData(0x2026),
          tooltip: 'More actions',
          label: 'More',
          entries: [MenuEntry(label: 'Ring', onSelected: () {})],
        ),
      ),
    );
    expect(find.text('More'), findsOneWidget);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Ring'), findsOneWidget);
  });

  testWidgets('a right-click opens the context menu at the pointer', (
    tester,
  ) async {
    final picked = <String>[];
    await tester.pumpWidget(
      app(
        ContextMenuRegion(
          entries: [
            MenuEntry(label: 'Forget', onSelected: () => picked.add('forget')),
          ],
          child: const SizedBox(width: 100, height: 30, child: Text('Pixel')),
        ),
      ),
    );
    expect(find.text('Forget'), findsNothing);

    await tester.tap(find.text('Pixel'), buttons: kSecondaryButton);
    await tester.pumpAndSettle();
    expect(find.text('Forget'), findsOneWidget);

    await tester.tap(find.text('Forget'));
    await tester.pumpAndSettle();
    expect(picked, ['forget']);
    expect(find.text('Forget'), findsNothing);
  });

  testWidgets('a context menu with nothing in it never opens', (tester) async {
    await tester.pumpWidget(
      app(const ContextMenuRegion(entries: [], child: Text('Pixel'))),
    );

    await tester.tap(find.text('Pixel'), buttons: kSecondaryButton);
    await tester.pumpAndSettle();
    expect(find.byType(OverlayPortal), findsNothing);
  });
}
