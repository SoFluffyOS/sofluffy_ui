import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

void main() {
  group('ColorHex', () {
    test('reads every web hex length, alpha last', () {
      expect(ColorHex.parse('#f00'), const Color(0xffff0000));
      expect(ColorHex.parse('f008'), const Color(0x88ff0000));
      expect(ColorHex.parse('#336699'), const Color(0xff336699));
      expect(ColorHex.parse(' #33669980 '), const Color(0x80336699));
    });

    test('anything else is no color', () {
      for (final text in ['', '#', '#12', '#12345', '#1234567', '#ggg']) {
        expect(ColorHex.parse(text), isNull, reason: text);
      }
    });

    test('writes alpha only when the color has some, or asked to', () {
      expect(ColorHex.format(const Color(0xff336699)), '#336699');
      expect(ColorHex.format(const Color(0x80336699)), '#33669980');
      expect(
        ColorHex.format(const Color(0xff336699), withAlpha: true),
        '#336699FF',
      );
    });
  });

  group('FluffyColorPicker', () {
    late List<Color> picked;
    late List<String> gestures;

    Widget picker({Color color = const Color(0xff336699), Color? original}) =>
        _app(
          FluffyColorPicker(
            color: color,
            original: original,
            onChanged: picked.add,
            onChangeStart: () => gestures.add('start'),
            onChangeEnd: () => gestures.add('end'),
          ),
        );

    setUp(() {
      picked = [];
      gestures = [];
    });

    testWidgets('a drag on the square is one gesture of many colors', (
      tester,
    ) async {
      await tester.pumpWidget(picker());
      final box = tester.getRect(find.byType(SaturationBox));

      final gesture = await tester.startGesture(box.center);
      await gesture.moveTo(box.topRight + const Offset(-1, 1));
      await gesture.up();
      await tester.pump();

      expect(gestures, ['start', 'end']);
      expect(picked.length, greaterThan(1));
      final last = HSVColor.fromColor(picked.last);
      expect(last.saturation, closeTo(1, 0.02));
      expect(last.value, closeTo(1, 0.02));
    });

    testWidgets('the hue strip turns the hue, keeping the rest', (
      tester,
    ) async {
      await tester.pumpWidget(picker(color: const Color(0xffff0000)));
      final strip = tester.getRect(find.byType(ColorStrip).first);

      await tester.tapAt(strip.center);
      await tester.pump();

      final hsv = HSVColor.fromColor(picked.last);
      expect(hsv.hue, closeTo(180, 2));
      expect(hsv.saturation, closeTo(1, 0.01));
    });

    testWidgets('a full hex typed applies; a short one only on Enter', (
      tester,
    ) async {
      await tester.pumpWidget(picker());
      final field = find.byType(EditableText);

      await tester.enterText(field, '#abc');
      await tester.pump();
      expect(picked, isEmpty);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(picked.last, const Color(0xffaabbcc));

      await tester.enterText(field, '#11223380');
      await tester.pump();
      expect(picked.last, const Color(0x80112233));
    });

    testWidgets('a click on the original goes back to it', (tester) async {
      await tester.pumpWidget(
        picker(
          color: const Color(0xff00ff00),
          original: const Color(0xff0000ff),
        ),
      );

      await tester.tap(find.byType(Tappable).first);
      await tester.pumpAndSettle();

      expect(picked.last, const Color(0xff0000ff));
      expect(gestures, ['start', 'end']);
    });

    testWidgets('a gray keeps the hue it had on the square', (tester) async {
      var color = const Color(0xffff0000);
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, rebuild) => FluffyColorPicker(
              color: color,
              onChanged: (next) => rebuild(() => color = next),
            ),
          ),
        ),
      );
      final strip = tester.getRect(find.byType(ColorStrip).first);
      await tester.tapAt(strip.center);
      await tester.pump();
      final box = tester.getRect(find.byType(SaturationBox));

      await tester.tapAt(box.topLeft + const Offset(1, 1));
      await tester.pump();
      await tester.tapAt(box.topRight + const Offset(-1, 1));
      await tester.pump();

      expect(HSVColor.fromColor(color).hue, closeTo(180, 2));
    });

    testWidgets('without alpha, there is no opacity strip', (tester) async {
      await tester.pumpWidget(
        _app(
          FluffyColorPicker(
            color: const Color(0xff336699),
            showAlpha: false,
            onChanged: picked.add,
          ),
        ),
      );

      expect(find.byType(ColorStrip), findsOneWidget);
    });
  });
}

Widget _app(Widget child) => WidgetsApp(
  color: const Color(0xff000000),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  ),
  builder: (context, widget) => FluffyTheme(
    data: FluffyThemeData.fallback(),
    child: widget ?? const SizedBox.shrink(),
  ),
  home: Center(
    child: SizedBox(width: Spacing.d280, child: child),
  ),
);
