part of 'multi_select_dropdown.dart';

class _MultiSelectMenu<T> extends StatelessWidget {
  const _MultiSelectMenu({
    required this.items,
    required this.selectedValues,
    required this.maxHeight,
    required this.onChanged,
    required this.onDismiss,
  });

  final List<MultiSelectDropdownItem<T>> items;
  final Set<T> selectedValues;
  final double maxHeight;
  final ValueChanged<Set<T>> onChanged;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final backgroundColor = switch (context.isDark) {
      true => theme.colors.neutral7,
      false => theme.colors.neutral1,
    };
    final borderColor = switch (context.isDark) {
      true => theme.colors.neutral5,
      false => theme.colors.neutral3,
    };

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          onDismiss();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shadows: [
            BoxShadow(
              color: FluffyColors.shadowMedium,
              blurRadius: Spacing.d12,
              offset: Offset(0, Spacing.d4),
            ),
          ],
          shape: RoundedSuperellipseBorder(
            borderRadius: Spacing.r12,
            side: BorderSide(color: borderColor, width: Spacing.d1),
          ),
        ),
        child: ClipRRect(
          borderRadius: Spacing.r12,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: Spacing.d4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in items)
                  _MultiSelectMenuItem<T>(
                    item: item,
                    value: selectedValues.contains(item.value),
                    onChanged: (selected) {
                      final values = Set<T>.of(selectedValues);
                      if (selected) {
                        values.add(item.value);
                      } else {
                        values.remove(item.value);
                      }
                      onChanged(values);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MultiSelectMenuItem<T> extends StatefulWidget {
  const _MultiSelectMenuItem({
    required this.item,
    required this.value,
    required this.onChanged,
  });

  final MultiSelectDropdownItem<T> item;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<_MultiSelectMenuItem<T>> createState() =>
      _MultiSelectMenuItemState<T>();
}

class _MultiSelectMenuItemState<T> extends State<_MultiSelectMenuItem<T>> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final hoverColor = switch ((_isHovering, context.isDark)) {
      (true, true) => theme.colors.neutral6,
      (true, false) => theme.colors.neutral2,
      _ => FluffyColors.transparent,
    };

    return DisableWidget(
      disabled: widget.item.enabled == false,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: AnimatedContainer(
          duration: FluffyDurations.fast,
          color: hoverColor,
          child: CheckBoxListTile(
            key: widget.item.key,
            value: widget.value,
            onChanged: widget.onChanged,
            title: widget.item.label,
            titleStyle: theme.typography.caption1,
          ),
        ),
      ),
    );
  }
}
