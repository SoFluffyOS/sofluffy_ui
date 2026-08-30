import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  testWidgets('aligns multiline hint with the first input line', (
    tester,
  ) async {
    await tester.pumpWidget(
      FluffyTheme(
        data: FluffyThemeData.fallback(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: Spacing.d280,
              child: const InputText(
                hintText: 'First line\nSecond line',
                maxLines: 4,
              ),
            ),
          ),
        ),
      ),
    );

    final hintTop = tester.getTopLeft(find.text('First line\nSecond line')).dy;
    final inputTop = tester.getTopLeft(find.byType(EditableText)).dy;

    expect(hintTop, inputTop);
  });
}
