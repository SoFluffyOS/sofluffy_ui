import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  testWidgets('keeps the menu open while toggling multiple values', (
    tester,
  ) async {
    var selectedValues = <String>{'windows'};
    await tester.pumpWidget(
      FluffyTheme(
        data: FluffyThemeData.fallback(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Center(
                  child: SizedBox(
                    width: Spacing.d280,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return MultiSelectDropdown<String>(
                          label: 'Windows',
                          items: const [
                            MultiSelectDropdownItem(
                              value: 'windows',
                              label: 'Windows',
                            ),
                            MultiSelectDropdownItem(
                              value: 'macos',
                              label: 'macOS',
                            ),
                          ],
                          selectedValues: selectedValues,
                          onChanged: (values) {
                            setState(() => selectedValues = values);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Windows').first);
    await tester.pump();
    expect(find.byType(CheckBoxListTile), findsNWidgets(2));

    await tester.tap(find.text('macOS'));
    await tester.pump();

    expect(selectedValues, {'windows', 'macos'});
    expect(find.byType(CheckBoxListTile), findsNWidgets(2));
  });
}
