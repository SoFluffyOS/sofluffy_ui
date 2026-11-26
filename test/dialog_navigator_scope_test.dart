import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

final _window = GlobalKey<NavigatorState>();

/// An app whose page holds a second navigator, as a second window would.
Widget _app({required bool scoped}) => FluffyTheme(
  data: FluffyThemeData.fallback(),
  child: WidgetsApp(
    color: const Color(0xFF000000),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    home: Center(
      child: SizedBox(
        width: 400,
        height: 400,
        child: Navigator(
          key: _window,
          onGenerateInitialRoutes: (_, _) => [
            PageRouteBuilder<void>(
              pageBuilder: (_, _, _) => switch (scoped) {
                true => DialogNavigatorScope(
                  navigatorKey: _window,
                  child: const _Opener(),
                ),
                false => const _Opener(),
              },
            ),
          ],
        ),
      ),
    ),
  ),
);

class _Opener extends StatelessWidget {
  const _Opener();

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => ConfirmDialog.show(
      context,
      title: 'Discard changes?',
      negativeText: 'Cancel',
      positiveText: 'Discard',
    ),
    child: const Text('open'),
  );
}

void main() {
  testWidgets('a dialog opens in the navigator of its scope', (tester) async {
    await tester.pumpWidget(_app(scoped: true));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final dialog = tester.element(find.text('Discard changes?'));
    expect(Navigator.of(dialog), _window.currentState);
  });

  testWidgets('outside a scope, it opens in the root navigator', (
    tester,
  ) async {
    await tester.pumpWidget(_app(scoped: false));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final dialog = tester.element(find.text('Discard changes?'));
    expect(Navigator.of(dialog), isNot(_window.currentState));
  });
}
