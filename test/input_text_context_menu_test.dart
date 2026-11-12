import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  const touchMenu = ValueKey('input-text-touch-menu');
  const overflowMenu = ValueKey('input-text-touch-menu-overflow');
  const moreButton = ValueKey('input-text-touch-menu-more');
  const backButton = ValueKey('input-text-touch-menu-back');
  const desktopMenu = ValueKey('input-text-context-menu');

  Future<void> openMenu(WidgetTester tester) async {
    final controller = TextEditingController(text: 'hello world');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFF000000),
        // Above the overlay the menu is drawn in, as in an app.
        builder: (context, child) => FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: child ?? const SizedBox.shrink(),
        ),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: Center(
          child: SizedBox(
            width: Spacing.d280,
            child: InputText(controller: controller),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    controller.selection = const TextSelection(baseOffset: 0, extentOffset: 5);
    await tester.pump();
    tester.state<EditableTextState>(find.byType(EditableText)).showToolbar();
    await tester.pumpAndSettle();
  }

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    testWidgets('$platform: a row of buttons sized for touch', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      await openMenu(tester);

      expect(find.byKey(touchMenu), findsOneWidget);
      expect(find.byKey(desktopMenu), findsNothing);
      expect(
        find.descendant(of: find.byKey(touchMenu), matching: find.text('Copy')),
        findsOneWidget,
      );
      debugDefaultTargetPlatformOverride = null;
    });
  }

  testWidgets('buttons that do not fit wait behind the more button', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    tester.view.physicalSize = const Size(200, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await openMenu(tester);

    expect(find.byKey(moreButton), findsOneWidget);
    expect(find.text('Select all'), findsNothing);

    await tester.tap(find.byKey(moreButton));
    await tester.pumpAndSettle();
    expect(find.byKey(overflowMenu), findsOneWidget);
    expect(find.text('Select all'), findsOneWidget);

    await tester.tap(find.byKey(backButton));
    await tester.pumpAndSettle();
    expect(find.byKey(touchMenu), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('desktop: the Fluffy text menu', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    await openMenu(tester);

    expect(find.byKey(desktopMenu), findsOneWidget);
    expect(find.byKey(touchMenu), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });
}
