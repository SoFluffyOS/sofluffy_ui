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
class WidgetbookApp extends StatefulWidget {
  final FluffyThemeData appTheme;

  const WidgetbookApp({super.key, required this.appTheme});

  @override
  State<WidgetbookApp> createState() => _WidgetbookAppState();
}

class _WidgetbookAppState extends State<WidgetbookApp> {
  ThemeMode _themeMode = ThemeMode.light;

  bool get _isDark => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final appTheme = widget.appTheme;
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
    // Place Overview category first
    final sortedDirectories = List.of(directories)
      ..sort((a, b) {
        if (a.name == 'Overview') return -1;
        if (b.name == 'Overview') return 1;
        return a.name.compareTo(b.name);
      });

    final widgetbook = Widgetbook.material(
      directories: sortedDirectories,
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
          initialTheme: _isDark ? themes.last : themes.first,
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
      themeMode: _themeMode,
    );

    // Global light/dark toggle for the whole Widgetbook shell.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widgetbook,
          Positioned(
            left: 12,
            bottom: 12,
            child: Material(
              color: _isDark ? Colors.white12 : Colors.black12,
              shape: const CircleBorder(),
              child: IconButton(
                icon: Icon(
                  _isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: _isDark ? Colors.white : Colors.black87,
                ),
                onPressed: () => setState(
                  () => _themeMode = _isDark ? ThemeMode.light : ThemeMode.dark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
