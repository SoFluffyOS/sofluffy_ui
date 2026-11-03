import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  Future<void> openMenu(WidgetTester tester) async {
    final controller = TextEditingController(text: 'hello world');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        // Above the overlay the menu is drawn in, as in an app.
        builder: (context, child) => FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: child ?? const SizedBox.shrink(),
        ),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: Spacing.d280,
              child: InputText(controller: controller),
            ),
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
    testWidgets('$platform: the platform text menu', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      await openMenu(tester);
      expect(find.byType(AdaptiveTextSelectionToolbar), findsOneWidget);
      expect(
        find.byKey(const ValueKey('input-text-context-menu')),
        findsNothing,
      );
      debugDefaultTargetPlatformOverride = null;
    });
  }

  testWidgets('desktop: the Fluffy text menu', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    await openMenu(tester);
    expect(find.byType(AdaptiveTextSelectionToolbar), findsNothing);
    expect(
      find.byKey(const ValueKey('input-text-context-menu')),
      findsOneWidget,
    );
    debugDefaultTargetPlatformOverride = null;
  });
}
