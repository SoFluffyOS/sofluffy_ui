import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  testWidgets('cancels a pending search when disposed', (tester) async {
    var searchCount = 0;
    await tester.pumpWidget(
      _SearchDialogHarness(
        onSearch: (query) async {
          searchCount++;
          return [query];
        },
      ),
    );

    await tester.enterText(find.byType(EditableText), 'query');
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 500));

    expect(searchCount, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ignores results from an older search generation', (
    tester,
  ) async {
    final firstResult = Completer<List<String>>();
    final secondResult = Completer<List<String>>();
    final queries = <String>[];
    await tester.pumpWidget(
      _SearchDialogHarness(
        onSearch: (query) {
          queries.add(query);
          return switch (query) {
            'first' => firstResult.future,
            _ => secondResult.future,
          };
        },
      ),
    );

    await tester.enterText(find.byType(EditableText), 'first');
    await tester.pump(const Duration(milliseconds: 500));
    expect(queries, ['first']);

    await tester.enterText(find.byType(EditableText), 'second');
    firstResult.complete(['stale result']);
    await tester.pump();
    expect(find.text('stale result'), findsNothing);

    await tester.pump(const Duration(milliseconds: 500));
    expect(queries, ['first', 'second']);
    secondResult.complete(['current result']);
    await tester.pump();
    expect(find.text('current result'), findsOneWidget);
  });
}

class _SearchDialogHarness extends StatelessWidget {
  const _SearchDialogHarness({required this.onSearch});

  final Future<List<String>> Function(String query) onSearch;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FluffyTheme(
        data: FluffyThemeData.fallback(),
        child: SearchDialog<String>(
          onSearch: onSearch,
          itemBuilder: (context, item, isSelected) => Text(item),
          onItemSelected: (_) {},
          searchIcon: '',
        ),
      ),
    );
  }
}
