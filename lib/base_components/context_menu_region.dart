import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/base_components/menu_overlay.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// Opens a short menu about [child] where the pointer is: on a right-click,
/// or a long press on a touch screen. With no [entries] it is [child] alone.
/// Everything in the menu must also be reachable without it.
class ContextMenuRegion extends StatefulWidget {
  const ContextMenuRegion({
    super.key,
    required this.entries,
    required this.child,
  });

  final List<MenuEntry> entries;
  final Widget child;

  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<ContextMenuRegion> {
  final OverlayPortalController _menu = OverlayPortalController();
  Offset _position = Offset.zero;

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return widget.child;
    }

    return OverlayPortal(
      controller: _menu,
      overlayChildBuilder: (_) => MenuOverlay(
        entries: widget.entries,
        onClose: _menu.hide,
        placement: (menu) => Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _AtPointer(_position, margin: Spacing.d8),
            child: menu,
          ),
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapUp: (details) => _open(details.globalPosition),
        onLongPressStart: (details) => _open(details.globalPosition),
        child: widget.child,
      ),
    );
  }

  void _open(Offset globalPosition) {
    final overlay = Overlay.of(context).context.findRenderObject();
    setState(() {
      _position = switch (overlay) {
        final RenderBox box => box.globalToLocal(globalPosition),
        _ => globalPosition,
      };
    });
    _menu.show();
  }
}

/// Puts the menu's corner at the pointer, moved back inside the overlay
/// when it would hang over an edge.
class _AtPointer extends SingleChildLayoutDelegate {
  const _AtPointer(this.position, {required this.margin});

  final Offset position;
  final double margin;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final maxLeft = size.width - childSize.width - margin;
    final maxTop = size.height - childSize.height - margin;

    return Offset(
      position.dx.clamp(margin, math.max(margin, maxLeft)),
      position.dy.clamp(margin, math.max(margin, maxTop)),
    );
  }

  @override
  bool shouldRelayout(_AtPointer oldDelegate) =>
      oldDelegate.position != position || oldDelegate.margin != margin;
}
