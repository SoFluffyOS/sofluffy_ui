import 'package:example/main.directories.g.dart';
import 'package:example/theme_adapter.dart';
import 'package:flutter/material.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appTheme = await ThemeLoader.loadDefault();
  runApp(WidgetbookApp(appTheme: appTheme));
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  final FluffyThemeData appTheme;

  const WidgetbookApp({super.key, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    final themes = [
      WidgetbookTheme(
        name: 'Light',
        data: appTheme.getTheme(isDark: false),
      ),
      WidgetbookTheme(
        name: 'Dark',
        data: appTheme.getTheme(isDark: true),
      ),
    ];
    return Widgetbook.material(
      directories: directories,
      addons: [
        ViewportAddon([
          Viewports.none,
          IosViewports.iPhone13,
          AndroidViewports.samsungGalaxyNote20,
          MacosViewports.macbookPro,
          WindowsViewports.desktop,
          LinuxViewports.desktop,
        ]),
        InspectorAddon(),
        TextScaleAddon(),
        MaterialThemeAddon(
          initialTheme: themes.first,
          themes: themes,
        ),
        BuilderAddon(
          name: 'FluffyTheme',
          builder: (context, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return FluffyTheme(
              data: appTheme.copyWith(
                brightness: switch (isDark) {
                  true => Brightness.dark,
                  false => Brightness.light,
                },
                platform: Theme.of(context).platform,
              ),
              child: child,
            );
          },
        ),
        BuilderAddon(
          name: 'Spacing',
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.all(Spacing.d24),
              child: child,
            );
          },
        ),
        AlignmentAddon(),
      ],
      themeMode: ThemeMode.light,
    );
  }
}
