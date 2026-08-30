import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

part 'multi_select_dropdown_chevron.dart';
part 'multi_select_dropdown_menu.dart';

class MultiSelectDropdownItem<T> {
  const MultiSelectDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
    this.key,
  });

  final T value;
  final String label;
  final bool enabled;
  final Key? key;
}

class MultiSelectDropdown<T> extends StatefulWidget {
  const MultiSelectDropdown({
    required this.items,
    required this.selectedValues,
    required this.label,
    required this.onChanged,
    this.maxMenuHeight,
    super.key,
  });

  final List<MultiSelectDropdownItem<T>> items;
  final Set<T> selectedValues;
  final String label;
  final ValueChanged<Set<T>> onChanged;
  final double? maxMenuHeight;

  @override
  State<MultiSelectDropdown<T>> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>> {
  final _anchorKey = GlobalKey();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isHovering = false;
  bool _isOpen = false;

  @override
  void didUpdateWidget(covariant MultiSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen == false) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _overlayEntry?.markNeedsBuild();
    });
  }

  @override
  void dispose() {
    _removeOverlay(updateState: false);
    super.dispose();
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
      return;
    }
    _showOverlay();
  }

  void _showOverlay() {
    final renderObject = _anchorKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final anchorSize = renderObject.size;
    final anchorOffset = renderObject.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxMenuHeight = widget.maxMenuHeight ?? Spacing.d280;
    final estimatedHeight = widget.items.length * Spacing.d40 + Spacing.d8;
    final menuHeight = switch (estimatedHeight < maxMenuHeight) {
      true => estimatedHeight,
      false => maxMenuHeight,
    };
    final spaceBelow =
        screenHeight - anchorOffset.dy - anchorSize.height - Spacing.d8;
    final openAbove = spaceBelow < menuHeight && anchorOffset.dy > spaceBelow;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: anchorSize.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: switch (openAbove) {
            true => Alignment.topLeft,
            false => Alignment.bottomLeft,
          },
          followerAnchor: switch (openAbove) {
            true => Alignment.bottomLeft,
            false => Alignment.topLeft,
          },
          offset: Offset(
            0,
            switch (openAbove) {
              true => -Spacing.d4,
              false => Spacing.d4,
            },
          ),
          child: TapRegion(
            groupId: _layerLink,
            onTapOutside: (_) => _removeOverlay(),
            child: _MultiSelectMenu<T>(
              items: widget.items,
              selectedValues: widget.selectedValues,
              maxHeight: maxMenuHeight,
              onChanged: widget.onChanged,
              onDismiss: _removeOverlay,
            ),
          ),
        ),
      ),
    );
    if (_overlayEntry case final overlayEntry?) {
      Overlay.of(context).insert(overlayEntry);
    }
    setState(() => _isOpen = true);
  }

  void _removeOverlay({bool updateState = true}) {
    final overlayEntry = _overlayEntry;
    _overlayEntry = null;
    overlayEntry?.remove();
    if (mounted == false || updateState == false || _isOpen == false) return;
    setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final isDesktop = switch (context.fluffyTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };
    final backgroundColor = switch (isDark) {
      true => theme.colors.neutral6,
      false => theme.colors.neutral2,
    };
    final borderColor = switch ((_isOpen, _isHovering, isDark)) {
      (true, _, true) => theme.colors.neutral5,
      (true, _, false) => theme.colors.neutral3,
      (false, true, _) => theme.colors.neutral4,
      _ => backgroundColor,
    };
    final foregroundColor = switch (isDark) {
      true => theme.colors.neutral1,
      false => theme.colors.neutral7,
    };

    return TapRegion(
      groupId: _layerLink,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: Semantics(
            button: true,
            expanded: _isOpen,
            label: widget.label,
            child: Tappable(
              key: _anchorKey,
              behavior: HitTestBehavior.opaque,
              enableAnimation: false,
              enableHover: false,
              onTap: _toggleOverlay,
              child: AnimatedContainer(
                duration: FluffyDurations.fast,
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: switch (isDesktop) {
                    true => Spacing.d12,
                    false => Spacing.d16,
                  },
                  vertical: switch (isDesktop) {
                    true => Spacing.d8,
                    false => Spacing.d14,
                  },
                ),
                decoration: ShapeDecoration(
                  color: backgroundColor,
                  shape: RoundedSuperellipseBorder(
                    borderRadius: Spacing.r12,
                    side: BorderSide(color: borderColor, width: Spacing.d2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: switch (isDesktop) {
                          true => theme.typography.caption1,
                          false => theme.typography.base2,
                        }.copyWith(color: foregroundColor),
                      ),
                    ),
                    Spacing.h8,
                    _DropdownChevron(
                      color: theme.colors.neutral4,
                      expanded: _isOpen,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
