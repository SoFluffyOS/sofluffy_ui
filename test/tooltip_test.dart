import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  Widget buildApp({
    required Widget child,
    Size size = const Size(800, 600),
  }) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: FluffyTheme(
          data: FluffyThemeData.fallback(),
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('FluffyTooltip', () {
    testWidgets('shows on hover and hides on exit', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: const Center(
            child: FluffyTooltip(
              message: 'Test Tooltip',
              child: Text('Hover target'),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      expect(find.text('Test Tooltip'), findsNothing);

      await gesture.moveTo(tester.getCenter(find.text('Hover target')));
      await tester.pump(FluffyDurations.tooltip);
      await tester.pumpAndSettle();

      expect(find.text('Test Tooltip'), findsOneWidget);

      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();

      expect(find.text('Test Tooltip'), findsNothing);
    });

    testWidgets(
      'disposed while showing does not crash or leave dirty render objects in overlay',
      (tester) async {
        final showWidgetNotifier = ValueNotifier<bool>(true);

        await tester.pumpWidget(
          buildApp(
            child: ValueListenableBuilder<bool>(
              valueListenable: showWidgetNotifier,
              builder: (context, showWidget, _) {
                return Stack(
                  children: [
                    if (showWidget)
                      const Positioned(
                        left: 100,
                        top: 100,
                        child: FluffyTooltip(
                          message: 'Disappearing Tooltip',
                          child: Text('Target Button'),
                        ),
                      ),
                    const Positioned(
                      left: 200,
                      top: 200,
                      child: Text('Other Element'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Hover to show tooltip
        await gesture.moveTo(tester.getCenter(find.text('Target Button')));
        await tester.pump(FluffyDurations.tooltip);
        await tester.pumpAndSettle();

        expect(find.text('Disappearing Tooltip'), findsOneWidget);

        // Unmount/dispose the widget while tooltip is showing (simulating pane addition / rebuild)
        showWidgetNotifier.value = false;
        await tester.pumpAndSettle();

        expect(find.text('Disappearing Tooltip'), findsNothing);

        // Moving mouse across the screen must NOT throw Null check operator used on a null value
        await gesture.moveTo(tester.getCenter(find.text('Other Element')));
        await gesture.down(tester.getCenter(find.text('Other Element')));
        await gesture.up();
        await tester.pumpAndSettle();
      },
    );

    testWidgets('clamps within window boundaries at screen edges', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          child: const Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: FluffyTooltip(
                  message: 'Top-left edge message',
                  child: Text('TopLeft'),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: FluffyTooltip(
                  message: 'Bottom-right edge message',
                  child: Text('BottomRight'),
                ),
              ),
            ],
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Hover TopLeft
      await gesture.moveTo(tester.getCenter(find.text('TopLeft')));
      await tester.pump(FluffyDurations.tooltip);
      await tester.pumpAndSettle();

      final topLeftRect = tester.getRect(find.text('Top-left edge message'));
      expect(topLeftRect.left, greaterThanOrEqualTo(Spacing.d8));
      expect(topLeftRect.top, greaterThanOrEqualTo(Spacing.d8));

      // Hover BottomRight
      await gesture.moveTo(tester.getCenter(find.text('BottomRight')));
      await tester.pump(FluffyDurations.tooltip);
      await tester.pumpAndSettle();

      final bottomRightRect = tester.getRect(
        find.text('Bottom-right edge message'),
      );
      expect(bottomRightRect.right, lessThanOrEqualTo(800.0 - Spacing.d8));
      expect(bottomRightRect.bottom, lessThanOrEqualTo(600.0 - Spacing.d8));
    });

    testWidgets('does not show tooltip when message is empty', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: const Center(
            child: FluffyTooltip(
              message: '',
              child: Text('No tooltip'),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('No tooltip')));
      await tester.pump(FluffyDurations.tooltip);
      await tester.pumpAndSettle();

      expect(find.byType(CustomSingleChildLayout), findsNothing);
    });

    testWidgets('integrates with Tappable without blocking clicks', (
      tester,
    ) async {
      int tapCount = 0;
      await tester.pumpWidget(
        buildApp(
          child: Center(
            child: Tappable(
              tooltip: 'Click me tooltip',
              onTap: () => tapCount++,
              child: const Text('Action Button'),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Hover button
      await gesture.moveTo(tester.getCenter(find.text('Action Button')));
      await tester.pump(FluffyDurations.tooltip);
      await tester.pumpAndSettle();

      expect(find.text('Click me tooltip'), findsOneWidget);

      // Click button while tooltip is visible
      await gesture.down(tester.getCenter(find.text('Action Button')));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapCount, 1);
    });

    testWidgets('updates displayed message when widget message changes', (
      tester,
    ) async {
      final messageNotifier = ValueNotifier<String>('Initial message');

      await tester.pumpWidget(
        buildApp(
          child: ValueListenableBuilder<String>(
            valueListenable: messageNotifier,
            builder: (context, message, _) {
              return Center(
                child: FluffyTooltip(
                  message: message,
                  child: const Text('Target'),
                ),
              );
            },
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Target')));
      await tester.pump(FluffyDurations.tooltip);
      await tester.pumpAndSettle();

      expect(find.text('Initial message'), findsOneWidget);

      messageNotifier.value = 'Updated message';
      await tester.pumpAndSettle();

      expect(find.text('Updated message'), findsOneWidget);
      expect(find.text('Initial message'), findsNothing);
    });

    testWidgets('cancels pending timer on rapid hover in and out', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          child: const Center(
            child: FluffyTooltip(
              message: 'Fast message',
              child: Text('Rapid Target'),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Hover in
      await gesture.moveTo(tester.getCenter(find.text('Rapid Target')));
      await tester.pump(const Duration(milliseconds: 50));

      // Quickly exit before 300ms duration
      await gesture.moveTo(Offset.zero);
      await tester.pump(FluffyDurations.tooltip);
      await tester.pumpAndSettle();

      expect(find.text('Fast message'), findsNothing);
    });
  });
}
