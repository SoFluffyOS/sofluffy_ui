import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

Future<void> _open(WidgetTester tester) async {
  await tester.pumpWidget(
    FluffyTheme(
      data: FluffyThemeData.fallback(),
      child: WidgetsApp(
        color: const Color(0xFF000000),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: Builder(
          builder: (context) => GestureDetector(
            onTap: () => InputTextDialog.show(
              context,
              title: 'Rename Branch',
              labelText: 'New name',
              cancelText: 'Cancel',
              confirmText: 'Rename',
              initialValue: 'feature/login',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('focuses the field with its value selected, ready to type', (
    tester,
  ) async {
    await _open(tester);

    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.focusNode.hasFocus, isTrue);
    expect(
      field.controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 13),
    );
  });

  testWidgets('on desktop, puts Cancel and the confirm button on the right', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await _open(tester);

    final actions = find.ancestor(
      of: find.text('Rename'),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Row &&
            widget.children.length == 3 &&
            widget.mainAxisAlignment == MainAxisAlignment.end,
      ),
    );
    final row = tester.getRect(actions.first);
    final rename = tester.getRect(
      find.ancestor(of: find.text('Rename'), matching: find.byType(Button)),
    );
    final cancel = tester.getRect(
      find.ancestor(of: find.text('Cancel'), matching: find.byType(Button)),
    );

    expect(rename.right, moreOrLessEquals(row.right));
    expect(rename.left - cancel.right, moreOrLessEquals(Spacing.d8));
    expect(cancel.left, greaterThan(row.left));
  });
}
