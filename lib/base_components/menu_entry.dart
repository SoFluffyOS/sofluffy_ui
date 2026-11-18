import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// One line of a [MenuButton]'s menu.
class MenuEntry {
  const MenuEntry({
    required this.label,
    required this.onSelected,
    this.icon,
    this.startsGroup = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onSelected;

  /// Draws a thin line above this entry, to set a new group apart.
  final bool startsGroup;
}
