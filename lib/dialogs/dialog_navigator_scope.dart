import 'package:flutter/widgets.dart';

/// Where the dialogs opened under it show: [navigatorKey]'s navigator, in
/// place of the root one.
///
/// Put one around each window of an app with more than one, so a dialog
/// opens in the window it was asked from. Every dialog of this package
/// follows it, such as [ConfirmDialog] and [ContentDialog].
class DialogNavigatorScope extends InheritedWidget {
  const DialogNavigatorScope({
    super.key,
    required this.navigatorKey,
    required super.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  /// The navigator dialogs opened from [context] go to, or null outside a
  /// scope, where they go to the root navigator.
  static NavigatorState? maybeOf(BuildContext context) => context
      .getInheritedWidgetOfExactType<DialogNavigatorScope>()
      ?.navigatorKey
      .currentState;

  /// What to show a dialog from [context] with: the scope's navigator, or
  /// [context] and its root navigator outside one.
  static ({BuildContext context, bool useRootNavigator}) routeOf(
    BuildContext context,
  ) => switch (maybeOf(context)) {
    final navigator? => (context: navigator.context, useRootNavigator: false),
    null => (context: context, useRootNavigator: true),
  };

  @override
  bool updateShouldNotify(DialogNavigatorScope oldWidget) =>
      oldWidget.navigatorKey != navigatorKey;
}
