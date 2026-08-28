import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/themes/app_theme.dart';
import 'package:sofluffy_ui/themes/typography.dart';

/// Theme provider that supplies [FluffyThemeData] and default text styling down the widget tree.
class FluffyTheme extends StatelessWidget {
  final FluffyThemeData data;
  final Widget child;

  const FluffyTheme({
    super.key,
    required this.data,
    required this.child,
  });

  /// Access the [FluffyThemeData] from the nearest [FluffyTheme] ancestor.
  static FluffyThemeData of(BuildContext context) {
    if (maybeOf(context) case final theme?) return theme;

    throw FlutterError(
      'FluffyTheme.of() called with a context that does not contain a '
      'FluffyTheme. Wrap the application or screen in FluffyTheme before '
      'using sofluffy_ui components. Use FluffyThemeData.fallback() as the '
      'provider data when default styling is intended.',
    );
  }

  /// Access the [FluffyThemeData] from the nearest [FluffyTheme] ancestor, or null if not found.
  static FluffyThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FluffyThemeInherited>()
        ?.data;
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = data.isDark ? data.colors.neutral1 : data.colors.neutral7;
    return _FluffyThemeInherited(
      data: data,
      child: DefaultTextStyle(
        style: data.typography.base2.copyWith(
          color: onSurface,
          decoration: TextDecoration.none,
        ),
        child: IconTheme(
          data: IconThemeData(
            color: onSurface,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _FluffyThemeInherited extends InheritedWidget {
  final FluffyThemeData data;

  const _FluffyThemeInherited({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _FluffyThemeInherited oldWidget) {
    return data != oldWidget.data;
  }
}

/// Extension on [BuildContext] for convenient theme access.
extension FluffyThemeExtension on BuildContext {
  /// Access the [FluffyThemeData] from [FluffyTheme].
  FluffyThemeData get fluffyTheme => FluffyTheme.of(this);

  /// Access the [FluffyThemeData] from [FluffyTheme], or null if not found.
  FluffyThemeData? get maybeFluffyTheme => FluffyTheme.maybeOf(this);

  /// Check whether the current theme or platform is dark mode.
  bool get isDark {
    final explicit = maybeFluffyTheme?.isDark;
    if (explicit != null) return explicit;
    return MediaQuery.maybePlatformBrightnessOf(this) == Brightness.dark;
  }

  /// Check whether the current theme or platform is light mode.
  bool get isLight => !isDark;
}
