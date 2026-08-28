import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  testWidgets('reports a missing FluffyTheme provider', (tester) async {
    late BuildContext contextWithoutTheme;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            contextWithoutTheme = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(
      () => FluffyTheme.of(contextWithoutTheme),
      throwsA(isA<FlutterError>()),
    );
  });

  testWidgets('uses the theme platform for responsive component sizing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FluffyTheme(
          data: FluffyThemeData.fallback().copyWith(
            platform: TargetPlatform.iOS,
          ),
          child: const Center(
            child: CheckBoxIcon(state: CheckBoxIconState.unchecked),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(CheckBoxIcon)), const Size(24, 24));
  });
}
