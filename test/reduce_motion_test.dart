import 'package:flutter/material.dart'
    show CircularProgressIndicator, LinearProgressIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  Widget app(Widget child, {required bool reducesMotion}) => MediaQuery(
    data: const MediaQueryData(),
    child: ReduceMotionScope(
      reducesMotion: reducesMotion,
      child: FluffyTheme(
        data: FluffyThemeData.fallback(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: child),
        ),
      ),
    ),
  );

  for (final reducesMotion in [false, true]) {
    testWidgets('motion keeps or drops durations (reduced: $reducesMotion)', (
      tester,
    ) async {
      late Duration duration;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) {
              duration = context.motion(FluffyDurations.fast);
              return const SizedBox();
            },
          ),
          reducesMotion: reducesMotion,
        ),
      );

      expect(duration, switch (reducesMotion) {
        true => Duration.zero,
        false => FluffyDurations.fast,
      });
    });
  }

  testWidgets('a spinner moves unless motion is reduced, then pulses', (
    tester,
  ) async {
    const spinner = ReducedMotionPulse(
      still: Text('still'),
      child: Text('moving'),
    );
    await tester.pumpWidget(app(spinner, reducesMotion: false));
    expect(find.text('moving'), findsOneWidget);
    expect(find.byType(GentlePulse), findsNothing);

    await tester.pumpWidget(app(spinner, reducesMotion: true));
    expect(find.text('still'), findsOneWidget);
    final opacity = tester
        .widget<FadeTransition>(
          find.ancestor(
            of: find.text('still'),
            matching: find.byType(FadeTransition),
          ),
        )
        .opacity;
    expect(opacity.value, 1);
    await tester.pump(GentlePulse.halfPeriod);
    expect(opacity.value, closeTo(GentlePulse.lowestOpacity, 0.001));
    await tester.pump(GentlePulse.halfPeriod);
    expect(opacity.value, closeTo(1, 0.001));
  });

  for (final reducesMotion in [false, true]) {
    testWidgets('a dialog fades in, and grows unless motion is reduced '
        '(reduced: $reducesMotion)', (tester) async {
      final animation = AnimationController(vsync: tester, value: 0);
      addTearDown(animation.dispose);
      await tester.pumpWidget(
        app(
          FluffyDialogTransition(
            animation: animation,
            child: const SizedBox.square(dimension: 10),
          ),
          reducesMotion: reducesMotion,
        ),
      );

      final scale = tester.widget<ScaleTransition>(
        find.byType(ScaleTransition),
      );
      expect(
        tester.widget<FadeTransition>(find.byType(FadeTransition)).opacity,
        animation,
      );
      expect(scale.scale.value, switch (reducesMotion) {
        true => 1.0,
        false => 0.95,
      });
    });
  }

  for (final reducesMotion in [false, true]) {
    testWidgets('pressing scales a tappable unless motion is reduced '
        '(reduced: $reducesMotion)', (tester) async {
      await tester.pumpWidget(
        app(
          Tappable(onTap: () {}, child: const SizedBox.square(dimension: 40)),
          reducesMotion: reducesMotion,
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(Tappable)),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final scales = tester
          .widgetList<AnimatedScale>(find.byType(AnimatedScale))
          .map((scale) => scale.scale);
      switch (reducesMotion) {
        case true:
          expect(scales, everyElement(1.0));
        case false:
          expect(scales, everyElement(lessThan(1.0)));
      }
      await gesture.up();
      await tester.pumpAndSettle();
    });
  }

  for (final reducesMotion in [false, true]) {
    testWidgets('a switch slides its thumb unless motion is reduced '
        '(reduced: $reducesMotion)', (tester) async {
      final value = ValueNotifier(false);
      addTearDown(value.dispose);
      await tester.pumpWidget(
        app(
          ValueListenableBuilder<bool>(
            valueListenable: value,
            builder: (_, on, _) => SwitchToggle(value: on, onChanged: (_) {}),
          ),
          reducesMotion: reducesMotion,
        ),
      );
      double thumbX() => tester
          .widget<Transform>(
            find
                .descendant(
                  of: find.byType(SwitchToggle),
                  matching: find.byType(Transform),
                )
                .first,
          )
          .transform
          .getTranslation()
          .x;
      final off = thumbX();

      value.value = true;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final early = thumbX();
      await tester.pumpAndSettle();
      final on = thumbX();

      expect(on, greaterThan(off));
      switch (reducesMotion) {
        case true:
          expect(early, on);
        case false:
          expect(early, allOf(greaterThan(off), lessThan(on)));
      }
    });
  }

  for (final reducesMotion in [false, true]) {
    testWidgets('a placeholder shimmers unless motion is reduced, then '
        'pulses (reduced: $reducesMotion)', (tester) async {
      await tester.pumpWidget(
        app(
          const LoadingBox(size: 20),
          reducesMotion: reducesMotion,
        ),
      );

      expect(find.byType(GentlePulse), switch (reducesMotion) {
        true => findsOneWidget,
        false => findsNothing,
      });
    });
  }

  for (final reducesMotion in [false, true]) {
    testWidgets('a spinner spins unless motion is reduced, then pulses a '
        'still ring (reduced: $reducesMotion)', (tester) async {
      await tester.pumpWidget(
        app(
          const FluffySpinner(strokeWidth: 2),
          reducesMotion: reducesMotion,
        ),
      );
      final ring = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(ring.strokeWidth, 2);
      switch (reducesMotion) {
        case true:
          expect(ring.value, ReducedMotionPulse.stillArc);
          expect(find.byType(GentlePulse), findsOneWidget);
        case false:
          expect(ring.value, isNull);
          expect(find.byType(GentlePulse), findsNothing);
      }
    });

    testWidgets('a bar sweeps unless motion is reduced, then pulses full '
        '(reduced: $reducesMotion)', (tester) async {
      await tester.pumpWidget(
        app(
          const FluffyProgressBar(minHeight: 1),
          reducesMotion: reducesMotion,
        ),
      );
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(bar.minHeight, 1);
      expect(bar.value, switch (reducesMotion) {
        true => 1,
        false => null,
      });
    });

    testWidgets('known progress shows as it is (reduced: $reducesMotion)', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const Column(
            children: [
              SizedBox.square(dimension: 20, child: FluffySpinner(value: 0.4)),
              FluffyProgressBar(value: 0.4),
            ],
          ),
          reducesMotion: reducesMotion,
        ),
      );

      expect(
        tester
            .widget<CircularProgressIndicator>(
              find.byType(CircularProgressIndicator),
            )
            .value,
        0.4,
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0.4,
      );
      expect(find.byType(GentlePulse), findsNothing);
    });
  }

  for (final reducesMotion in [false, true]) {
    testWidgets('scrolling glides unless motion is reduced, then jumps '
        '(reduced: $reducesMotion)', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      late BuildContext listContext;
      await tester.pumpWidget(
        app(
          SizedBox(
            height: 100,
            child: Builder(
              builder: (context) {
                listContext = context;
                return ListView(
                  controller: controller,
                  children: const [SizedBox(height: 1000)],
                );
              },
            ),
          ),
          reducesMotion: reducesMotion,
        ),
      );

      final scrolled = controller.scrollTo(
        listContext,
        500,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      switch (reducesMotion) {
        case true:
          expect(controller.offset, 500);
        case false:
          expect(controller.offset, closeTo(250, 1));
      }
      await tester.pumpAndSettle();
      await scrolled;
      expect(controller.offset, 500);
    });
  }
}
