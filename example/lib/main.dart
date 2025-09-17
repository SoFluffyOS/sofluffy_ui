import 'package:design_system/design_system.dart';
import 'package:example/main.directories.g.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeConfigs().init();
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = [
      WidgetbookTheme(
        name: 'Light',
        data: ThemeConfigs().theme.getTheme(isDark: false),
      ),
      WidgetbookTheme(
        name: 'Dark',
        data: ThemeConfigs().theme.getTheme(isDark: true),
      ),
    ];
    return Widgetbook.material(
      // The [directories] variable1 does not exist yet,
      // it will be generated in the next step
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
