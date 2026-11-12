part of 'input_text.dart';

/// The text menu on touch screens without a system menu (Android, and iOS
/// before 16): a row of buttons by the selection. Buttons that don't fit
/// wait behind a more button, which swaps the row for a list of them.
class _InputTextTouchMenu extends StatefulWidget {
  const _InputTextTouchMenu({
    required this.theme,
    required this.anchors,
    required this.buttonItems,
  });

  final FluffyThemeData theme;
  final TextSelectionToolbarAnchors anchors;
  final List<ContextMenuButtonItem> buttonItems;

  @override
  State<_InputTextTouchMenu> createState() => _InputTextTouchMenuState();
}

class _InputTextTouchMenuState extends State<_InputTextTouchMenu> {
  bool _showsOverflow = false;

  @override
  Widget build(BuildContext context) {
    if (widget.buttonItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final anchors = widget.anchors;
    final fallbackAnchor = anchors.secondaryAnchor ?? anchors.primaryAnchor;

    return FluffyTheme(
      data: widget.theme,
      child: Padding(
        padding: EdgeInsets.all(Spacing.d8),
        child: CustomSingleChildLayout(
          delegate: TextSelectionToolbarLayoutDelegate(
            anchorAbove:
                anchors.primaryAnchor - Offset(Spacing.d8, Spacing.d16),
            anchorBelow: fallbackAnchor - Offset(Spacing.d8, 0),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) =>
                _buildMenu(context, constraints.maxWidth),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, double maxWidth) {
    final buttonItems = widget.buttonItems;
    final fittingCount = _fittingCount(context, maxWidth);
    final overflowItems = buttonItems.sublist(fittingCount);

    if (_showsOverflow) {
      return _TouchMenuPanel(
        key: const ValueKey('input-text-touch-menu-overflow'),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Spacing.d200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TouchMenuButton(
                key: const ValueKey('input-text-touch-menu-back'),
                label: '‹',
                alignment: Alignment.centerLeft,
                onPressed: () => setState(() => _showsOverflow = false),
              ),
              for (final buttonItem in overflowItems)
                _TouchMenuButton(
                  label: _touchMenuLabel(context, buttonItem),
                  alignment: Alignment.centerLeft,
                  onPressed: buttonItem.onPressed,
                ),
            ],
          ),
        ),
      );
    }

    return _TouchMenuPanel(
      key: const ValueKey('input-text-touch-menu'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final buttonItem in buttonItems.take(fittingCount))
            _TouchMenuButton(
              label: _touchMenuLabel(context, buttonItem),
              onPressed: buttonItem.onPressed,
            ),
          if (overflowItems.isNotEmpty)
            _TouchMenuButton(
              key: const ValueKey('input-text-touch-menu-more'),
              label: '⋯',
              onPressed: () => setState(() => _showsOverflow = true),
            ),
        ],
      ),
    );
  }

  /// How many buttons fit in a row [maxWidth] wide, leaving room for the
  /// more button when some don't. At least one always shows.
  int _fittingCount(BuildContext context, double maxWidth) {
    final style = _TouchMenuButton.labelStyle(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);

    double widthOf(String label) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: textDirection,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      final width = painter.width + _TouchMenuButton.horizontalPadding * 2;
      painter.dispose();
      return width;
    }

    final buttonItems = widget.buttonItems;
    final widths = [
      for (final buttonItem in buttonItems)
        widthOf(_touchMenuLabel(context, buttonItem)),
    ];

    final totalWidth = widths.fold<double>(0, (sum, width) => sum + width);
    if (totalWidth <= maxWidth) {
      return buttonItems.length;
    }

    final widthBeforeMore = maxWidth - widthOf('⋯');
    var usedWidth = 0.0;
    var count = 0;
    for (final width in widths) {
      if (usedWidth + width > widthBeforeMore) {
        break;
      }
      usedWidth += width;
      count++;
    }
    return switch (count) {
      0 => 1,
      _ => count,
    };
  }
}

String _touchMenuLabel(BuildContext context, ContextMenuButtonItem buttonItem) {
  if (buttonItem.label case final label? when label.isNotEmpty) {
    return label;
  }

  final localizations = WidgetsLocalizations.of(context);
  return switch (buttonItem.type) {
    ContextMenuButtonType.cut => localizations.cutButtonLabel,
    ContextMenuButtonType.copy => localizations.copyButtonLabel,
    ContextMenuButtonType.paste => localizations.pasteButtonLabel,
    ContextMenuButtonType.selectAll => localizations.selectAllButtonLabel,
    ContextMenuButtonType.lookUp => localizations.lookUpButtonLabel,
    ContextMenuButtonType.searchWeb => localizations.searchWebButtonLabel,
    ContextMenuButtonType.share => localizations.shareButtonLabel,
    ContextMenuButtonType.delete => 'Delete',
    ContextMenuButtonType.liveTextInput => 'Scan Text',
    ContextMenuButtonType.custom => '',
  };
}

class _TouchMenuPanel extends StatelessWidget {
  const _TouchMenuPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _contextMenuDecoration(context),
      child: ClipRSuperellipse(borderRadius: Spacing.r8, child: child),
    );
  }
}

class _TouchMenuButton extends StatefulWidget {
  const _TouchMenuButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.alignment = Alignment.center,
  });

  static double get horizontalPadding => Spacing.d12;

  static TextStyle labelStyle(BuildContext context) =>
      context.fluffyTheme.typography.body2;

  final String label;
  final VoidCallback? onPressed;
  final AlignmentGeometry alignment;

  @override
  State<_TouchMenuButton> createState() => _TouchMenuButtonState();
}

class _TouchMenuButtonState extends State<_TouchMenuButton> {
  bool _isPressed = false;

  void _setPressed(bool isPressed) {
    if (widget.onPressed == null) {
      return;
    }

    setState(() => _isPressed = isPressed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final foregroundColor = switch (context.isDark) {
      true => theme.colors.neutral1,
      false => theme.colors.neutral7,
    };
    final onPressed = widget.onPressed;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: Container(
        height: Spacing.d44,
        padding: EdgeInsets.symmetric(
          horizontal: _TouchMenuButton.horizontalPadding,
        ),
        color: switch (_isPressed) {
          true => theme.colors.primary.withValues(alpha: 0.1),
          false => FluffyColors.transparent,
        },
        alignment: widget.alignment,
        child: Text(
          widget.label,
          maxLines: 1,
          style: _TouchMenuButton.labelStyle(context).copyWith(
            color: switch (onPressed) {
              null => foregroundColor.withValues(alpha: 0.4),
              _ => foregroundColor,
            },
          ),
        ),
      ),
    );
  }
}
