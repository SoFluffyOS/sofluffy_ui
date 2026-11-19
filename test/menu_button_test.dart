import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
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

  testWidgets('arrow keys walk the entries and Enter picks one', (
    tester,
  ) async {
    final picked = <String>[];
    await tester.pumpWidget(
      app(
        MenuButton(
          icon: const IconData(0x2026),
          tooltip: 'More',
          entries: [
            for (final label in ['Add', 'Settings', 'Quit'])
              MenuEntry(label: label, onSelected: () => picked.add(label)),
          ],
        ),
      ),
    );
    await tester.tap(find.byType(MenuButton));
    await tester.pumpAndSettle();

    String? focused() {
      final focus = FocusManager.instance.primaryFocus?.context;
      if (focus == null) {
        return null;
      }

      final label = find.descendant(
        of: find.byElementPredicate((element) => element == focus),
        matching: find.byType(Text),
      );
      return tester.widget<Text>(label.first).data;
    }

    Future<void> press(LogicalKeyboardKey key) async {
      await tester.sendKeyEvent(key);
      await tester.pump();
    }

    await press(LogicalKeyboardKey.arrowDown);
    expect(focused(), 'Add');
    await press(LogicalKeyboardKey.arrowDown);
    expect(focused(), 'Settings');
    await press(LogicalKeyboardKey.arrowUp);
    await press(LogicalKeyboardKey.arrowUp);
    expect(focused(), 'Quit', reason: 'up from the first goes to the last');
    await press(LogicalKeyboardKey.arrowDown);
    expect(focused(), 'Add', reason: 'down from the last goes to the first');
    await press(LogicalKeyboardKey.end);
    expect(focused(), 'Quit');
    await press(LogicalKeyboardKey.home);
    await press(LogicalKeyboardKey.arrowDown);
    expect(focused(), 'Settings');

    await press(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(picked, ['Settings']);
    expect(find.text('Quit'), findsNothing);
  });

  testWidgets('an entry shows its shortcut after the label', (tester) async {
    await tester.pumpWidget(
      app(
        MenuButton(
          icon: const IconData(0x2026),
          tooltip: 'More',
          entries: [
            MenuEntry(
              label: 'Add a device',
              shortcut: 'Ctrl+N',
              onSelected: () {},
            ),
            MenuEntry(label: 'Quit', onSelected: () {}),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(MenuButton));
    await tester.pumpAndSettle();

    expect(find.text('Ctrl+N'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Ctrl+N')).dx,
      greaterThan(tester.getTopRight(find.text('Add a device')).dx),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('opensRight starts the menu at the icon', (tester) async {
    await tester.pumpWidget(
      app(
        MenuButton(
          icon: const IconData(0x2026),
          tooltip: 'More',
          opensRight: true,
          entries: [MenuEntry(label: 'A long entry here', onSelected: () {})],
        ),
      ),
    );

    await tester.tap(find.byType(MenuButton));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('A long entry here')).dx,
      greaterThan(tester.getTopLeft(find.byType(MenuButton)).dx),
    );
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

    final pointer = tester.getCenter(find.text('Pixel'));
    final menu = tester.getRect(find.text('Forget'));
    expect(menu.top, greaterThan(pointer.dy));
    expect(menu.top - pointer.dy, lessThan(40));

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
