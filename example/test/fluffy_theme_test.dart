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
}
