part of 'input_text.dart';

class _InputTextContextMenu extends StatelessWidget {
  const _InputTextContextMenu({
    required this.anchors,
    required this.buttonItems,
  });

  final TextSelectionToolbarAnchors anchors;
  final List<ContextMenuButtonItem> buttonItems;

  @override
  Widget build(BuildContext context) {
    if (buttonItems.isEmpty) return const SizedBox.shrink();

    final fallbackAnchor = anchors.secondaryAnchor ?? anchors.primaryAnchor;
    return Padding(
      padding: EdgeInsets.all(Spacing.d8),
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchors.primaryAnchor - Offset(Spacing.d8, Spacing.d8),
          anchorBelow: fallbackAnchor + Offset(Spacing.d8, Spacing.d8),
        ),
        child: _InputTextContextMenuPanel(buttonItems: buttonItems),
      ),
    );
  }
}

class _InputTextContextMenuPanel extends StatelessWidget {
  const _InputTextContextMenuPanel({required this.buttonItems});

  final List<ContextMenuButtonItem> buttonItems;

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final backgroundColor = switch (isDark) {
      true => theme.colors.neutral6,
      false => theme.colors.neutral2,
    };
    final borderColor = switch (isDark) {
      true => theme.colors.neutral5,
      false => theme.colors.neutral3,
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Spacing.d200),
      child: DecoratedBox(
        key: const ValueKey('input-text-context-menu'),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedSuperellipseBorder(
            borderRadius: Spacing.r8,
            side: BorderSide(
              color: borderColor,
              width: Spacing.d1,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          shadows: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.1),
              blurRadius: Spacing.d1,
              spreadRadius: Spacing.d1,
            ),
            BoxShadow(
              color: FluffyColors.shadowMedium,
              blurRadius: Spacing.d12,
              offset: Offset(0, Spacing.d4),
            ),
          ],
        ),
        child: ClipRSuperellipse(
          borderRadius: Spacing.r8,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Spacing.d4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final buttonItem in buttonItems)
                  _InputTextContextMenuItem(buttonItem: buttonItem),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputTextContextMenuItem extends StatefulWidget {
  const _InputTextContextMenuItem({required this.buttonItem});

  final ContextMenuButtonItem buttonItem;

  @override
  State<_InputTextContextMenuItem> createState() =>
      _InputTextContextMenuItemState();
}

class _InputTextContextMenuItemState extends State<_InputTextContextMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final foregroundColor = switch (isDark) {
      true => theme.colors.neutral1,
      false => theme.colors.neutral7,
    };
    final onPressed = widget.buttonItem.onPressed;

    return MouseRegion(
      cursor: switch (onPressed) {
        null => SystemMouseCursors.basic,
        _ => SystemMouseCursors.click,
      },
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          height: Spacing.d28,
          padding: EdgeInsets.symmetric(horizontal: Spacing.d12),
          color: switch (_isHovered && onPressed != null) {
            true => theme.colors.primary.withValues(alpha: 0.1),
            false => FluffyColors.transparent,
          },
          alignment: Alignment.centerLeft,
          child: Text(
            _labelFor(widget.buttonItem),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.typography.caption1.copyWith(
              color: switch (onPressed) {
                null => foregroundColor.withValues(alpha: 0.4),
                _ => foregroundColor,
              },
            ),
          ),
        ),
      ),
    );
  }

  String _labelFor(ContextMenuButtonItem buttonItem) {
    if (buttonItem.label case final label? when label.isNotEmpty) return label;

    return switch (buttonItem.type) {
      ContextMenuButtonType.cut => 'Cut',
      ContextMenuButtonType.copy => 'Copy',
      ContextMenuButtonType.paste => 'Paste',
      ContextMenuButtonType.selectAll => 'Select All',
      ContextMenuButtonType.delete => 'Delete',
      ContextMenuButtonType.lookUp => 'Look Up',
      ContextMenuButtonType.searchWeb => 'Search Web',
      ContextMenuButtonType.share => 'Share',
      ContextMenuButtonType.liveTextInput => 'Scan Text',
      ContextMenuButtonType.custom => '',
    };
  }
}
