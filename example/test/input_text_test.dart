import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  testWidgets('accessories do not increase the desktop input height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback().copyWith(
            platform: TargetPlatform.macOS,
          ),
          child: Center(
            child: SizedBox(
              width: Spacing.d320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const InputText(key: ValueKey('plain'), hintText: 'Plain'),
                  InputText(
                    key: const ValueKey('prefix'),
                    hintText: 'Prefix',
                    prefix: SizedBox.square(dimension: Spacing.d18),
                  ),
                  InputText(
                    key: const ValueKey('suffix'),
                    hintText: 'Suffix',
                    suffix: SizedBox.square(dimension: Spacing.d18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final plainHeight = tester
        .getSize(find.byKey(const ValueKey('plain')))
        .height;

    expect(plainHeight, Spacing.d32);
    expect(
      tester.getSize(find.byKey(const ValueKey('prefix'))).height,
      plainHeight,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('suffix'))).height,
      plainHeight,
    );
  });

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

  testWidgets('disables personalized input and selection for passwords', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: const Center(
            child: InputText(
              obscureText: true,
              isPasswordField: true,
            ),
          ),
        ),
      ),
    );

    final editableText = tester.widget<EditableText>(find.byType(EditableText));
    expect(editableText.enableIMEPersonalizedLearning, isFalse);
    expect(editableText.enableInteractiveSelection, isFalse);
    expect(editableText.autocorrect, isFalse);
    expect(editableText.enableSuggestions, isFalse);
  });

  testWidgets('does not dispose caller-owned input resources', (tester) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: InputText(
            controller: controller,
            focusNode: focusNode,
          ),
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());

    expect(() => controller.text = 'still owned by caller', returnsNormally);
    expect(focusNode.requestFocus, returnsNormally);
  });
}
