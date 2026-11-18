import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/base_components/menu_overlay.dart';
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
    this.label,
  });

  final IconData icon;
  final String tooltip;

  /// Draws the button outlined with this next to the icon, for a menu that
  /// sits in a row of buttons, such as "More".
  final String? label;
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
        overlayChildBuilder: (_) => MenuOverlay(
          entries: widget.entries,
          onClose: _menu.hide,
          placement: (menu) => Positioned(
            left: 0,
            top: 0,
            child: CompositedTransformFollower(
              link: _anchor,
              showWhenUnlinked: false,
              targetAnchor: _side.$1,
              followerAnchor: _side.$2,
              offset: Offset(0, Spacing.d4),
              child: menu,
            ),
          ),
        ),
        child: _button(context),
      ),
    );
  }

  /// An icon sits at the end of a toolbar, so its menu grows back from the
  /// icon's right edge. A labelled button sits among others, so its menu
  /// starts at the button's left edge.
  (Alignment, Alignment) get _side => switch (widget.label) {
    null => (Alignment.bottomRight, Alignment.topRight),
    _ => (Alignment.bottomLeft, Alignment.topLeft),
  };

  Widget _button(BuildContext context) {
    final label = widget.label;
    if (label != null) {
      return Button(
        variant: ButtonVariant.ghost,
        mainAxisSize: MainAxisSize.min,
        label: label,
        tooltip: widget.tooltip,
        icon: Icon(widget.icon, size: Spacing.d16),
        onPressed: _menu.toggle,
      );
    }

    return Tappable(
      tooltip: widget.tooltip,
      onTap: _menu.toggle,
      child: Padding(
        padding: EdgeInsets.all(Spacing.d6),
        child: Icon(
          widget.icon,
          size: Spacing.d20,
          color: MenuColors.of(context).text,
        ),
      ),
    );
  }
}
