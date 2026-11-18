import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// An icon that opens a short menu right under itself. The menu closes on
/// a pick, a tap anywhere else, or Escape. Used where a dialog would be too
/// much, such as a "more" menu in a toolbar.
class MenuButton extends StatefulWidget {
  const MenuButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.entries,
  });

  final IconData icon;
  final String tooltip;
  final List<MenuEntry> entries;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  final OverlayPortalController _menu = OverlayPortalController();
  final LayerLink _anchor = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _anchor,
      child: OverlayPortal(
        controller: _menu,
        overlayChildBuilder: (_) => _MenuOverlay(
          anchor: _anchor,
          entries: widget.entries,
          onClose: _menu.hide,
        ),
        child: Tappable(
          tooltip: widget.tooltip,
          onTap: _menu.toggle,
          child: Padding(
            padding: EdgeInsets.all(Spacing.d6),
            child: Icon(
              widget.icon,
              size: Spacing.d20,
              color: _MenuColors.of(context).text,
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuOverlay extends StatelessWidget {
  const _MenuOverlay({
    required this.anchor,
    required this.entries,
    required this.onClose,
  });

  final LayerLink anchor;
  final List<MenuEntry> entries;
  final VoidCallback onClose;

  static const _shadow = Color(0x33000000);

  @override
  Widget build(BuildContext context) {
    final palette = _MenuColors.of(context);

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
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: CompositedTransformFollower(
                link: anchor,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: Offset(0, Spacing.d4),
                child: DecoratedBox(
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
    final palette = _MenuColors.of(context);

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
        color: _MenuColors.of(context).mutedText.withValues(alpha: 0.2),
        child: SizedBox(height: Spacing.d1),
      ),
    );
  }
}

/// The menu's colours, picked from the Fluffy theme for light and dark.
class _MenuColors {
  const _MenuColors._(this._theme);

  factory _MenuColors.of(BuildContext context) =>
      _MenuColors._(context.fluffyTheme);

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
