import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// The open menu of a [MenuButton] or a [ContextMenuRegion]: its entries
/// on a card, over a layer that closes it on a tap anywhere else or Escape.
class MenuOverlay extends StatelessWidget {
  const MenuOverlay({
    super.key,
    required this.entries,
    required this.onClose,
    required this.placement,
  });

  /// Puts the menu's card where it belongs in the overlay's `Stack`.
  final Widget Function(Widget menu) placement;
  final List<MenuEntry> entries;
  final VoidCallback onClose;

  static const _shadow = Color(0x33000000);

  @override
  Widget build(BuildContext context) {
    final palette = MenuColors.of(context);

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): onClose},
      child: Focus(
        autofocus: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                onSecondaryTap: onClose,
              ),
            ),
            placement(
              DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(Spacing.d12),
                  boxShadow: [
                    BoxShadow(
                      color: _shadow,
                      blurRadius: Spacing.d24,
                      offset: Offset(0, Spacing.d8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Spacing.d6),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final entry in entries) ...[
                          if (entry.startsGroup) const _Divider(),
                          _MenuRow(
                            entry: entry,
                            keepsIconSpace: entries.any(
                              (other) => other.icon != null,
                            ),
                            onClose: onClose,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.entry,
    required this.keepsIconSpace,
    required this.onClose,
  });

  final MenuEntry entry;

  /// Lines up the labels when only some entries have an icon.
  final bool keepsIconSpace;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final palette = MenuColors.of(context);

    return Tappable(
      onTap: () {
        onClose();
        entry.onSelected();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.d16,
          vertical: Spacing.d10,
        ),
        child: Row(
          children: [
            if (entry.icon case final icon?)
              Icon(icon, size: Spacing.d16, color: palette.mutedText),
            if (entry.icon == null && keepsIconSpace)
              SizedBox(width: Spacing.d16),
            if (keepsIconSpace) Spacing.h12,
            Text(
              entry.label,
              style: context.fluffyTheme.typography.base2.copyWith(
                color: palette.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.d6),
      child: ColoredBox(
        color: MenuColors.of(context).mutedText.withValues(alpha: 0.2),
        child: SizedBox(height: Spacing.d1),
      ),
    );
  }
}

/// The menu's colours, picked from the Fluffy theme for light and dark.
class MenuColors {
  const MenuColors._(this._theme);

  factory MenuColors.of(BuildContext context) =>
      MenuColors._(context.fluffyTheme);

  final FluffyThemeData _theme;

  Color get surface => switch (_theme.isDark) {
    true => _theme.colors.neutral6,
    false => _theme.colors.neutral2,
  };

  Color get text => switch (_theme.isDark) {
    true => _theme.colors.neutral1,
    false => _theme.colors.neutral7,
  };

  Color get mutedText => switch (_theme.isDark) {
    true => _theme.colors.neutral4,
    false => _theme.colors.neutral5,
  };
}
