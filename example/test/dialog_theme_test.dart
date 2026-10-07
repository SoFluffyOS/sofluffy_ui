import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  testWidgets('carries a screen-level FluffyTheme into dialog routes', (
    tester,
  ) async {
    const primaryColor = Color(0xFF123456);
    final theme = FluffyThemeData.fallback().copyWith(
      colors: ColorData.fallback().copyWith(primary: primaryColor),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: theme,
          child: Builder(
            builder: (context) {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    await ConfirmDialog.show(
                      context,
                      title: 'Confirm',
                      negativeText: 'Cancel',
                      positiveText: 'OK',
                    );
                  },
                  child: const Text('Open'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final dialogContext = tester.element(find.byType(DialogCard));
    expect(dialogContext.fluffyTheme.colors.primary, primaryColor);
  });

  testWidgets('keeps long confirmation actions within the dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: Builder(
            builder: (context) {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    await ConfirmDialog.show(
                      context,
                      title: 'Confirm',
                      negativeText: 'Cancel',
                      positiveText: 'Paste Anyway',
                    );
                  },
                  child: const Text('Open'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(DialogCard)).width,
      greaterThanOrEqualTo(Spacing.d320),
    );
  });

  testWidgets('RadioOptionsDialog inherits FluffyTheme properly', (
    tester,
  ) async {
    const primaryColor = Color(0xFF123456);
    final theme = FluffyThemeData.fallback().copyWith(
      colors: ColorData.fallback().copyWith(primary: primaryColor),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: theme,
          child: Builder(
            builder: (context) {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    await RadioOptionsDialog.show<String>(
                      context,
                      title: 'Select Format',
                      message: 'Choose format',
                      values: ['mp4', 'mkv'],
                      initialValue: 'mp4',
                      itemLabelBuilder: (val) => val.toUpperCase(),
                      confirmText: 'Confirm',
                      cancelText: 'Cancel',
                    );
                  },
                  child: const Text('Open'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final dialogContext = tester.element(find.byType(DialogCard));
    expect(dialogContext.fluffyTheme.colors.primary, primaryColor);
  });
}
