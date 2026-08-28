import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  testWidgets('shows the styled text context menu on secondary click', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'hello world');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: Center(
            child: SizedBox(
              width: Spacing.d280,
              child: InputText(controller: controller),
            ),
          ),
        ),
      ),
    );

    await tester.tap(
      find.byType(EditableText),
      buttons: kSecondaryMouseButton,
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('input-text-context-menu')),
      findsOneWidget,
    );
    expect(find.text('Select All'), findsOneWidget);

    await tester.tap(find.text('Select All'));
    await tester.pump();

    expect(
      controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 11),
    );
  });
}
