import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class FluffyTooltip extends StatefulWidget {
  const FluffyTooltip({
    super.key,
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  @override
  State<FluffyTooltip> createState() => _FluffyTooltipState();
}

class _FluffyTooltipState extends State<FluffyTooltip> {
  OverlayEntry? _entry;
  Timer? _showTimer;

  void _show(PointerEnterEvent event) {
    if (widget.message.isEmpty) return;
    _showTimer?.cancel();
    _showTimer = Timer(FluffyDurations.tooltip, _showTooltip);
  }

  void _hide() {
    _showTimer?.cancel();
    _showTimer = null;
    final entry = _entry;
    if (entry == null) return;
    try {
      entry.remove();
    } catch (_) {}
    entry.dispose();
    _entry = null;
  }

  void _showTooltip() {
    if (!mounted || widget.message.isEmpty) return;
    if (_entry != null) return;

    final renderBox = context.findRenderObject();
    if (renderBox is! RenderBox || !renderBox.hasSize) return;

    final targetRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (overlayContext) {
        final currentRenderBox = context.findRenderObject();
        final currentRect = switch (currentRenderBox) {
          final RenderBox box when box.hasSize =>
            box.localToGlobal(Offset.zero) & box.size,
          _ => targetRect,
        };
        final currentTheme = context.fluffyTheme;
        final currentWindowSize = MediaQuery.sizeOf(overlayContext);
        final currentAvailableHeight = math.max(
          Spacing.d0,
          currentWindowSize.height - Spacing.d16,
        );
        final currentMaxTextLines =
            switch (((currentAvailableHeight - Spacing.d8) / Spacing.d16)
                .floor()) {
              < 1 => 1,
              final count => count,
            };

        final currentBgColor = switch (currentTheme.isDark) {
          true => currentTheme.colors.neutral6,
          false => currentTheme.colors.neutral2,
        };
        final currentBorderColor = switch (currentTheme.isDark) {
          true => currentTheme.colors.neutral5,
          false => currentTheme.colors.neutral3,
        };
        final currentFgColor = switch (currentTheme.isDark) {
          true => currentTheme.colors.neutral1,
          false => currentTheme.colors.neutral7,
        };

        return Positioned.fill(
          child: IgnorePointer(
            child: CustomSingleChildLayout(
              delegate: _TooltipLayoutDelegate(
                targetRect: currentRect,
                margin: Spacing.d8,
              ),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: currentBgColor,
                  shape: RoundedSuperellipseBorder(
                    borderRadius: Spacing.r8,
                    side: BorderSide(
                      color: currentBorderColor,
                      width: Spacing.d1,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: FluffyColors.shadowMedium,
                      blurRadius: Spacing.d12,
                      offset: Offset(Spacing.d0, Spacing.d4),
                    ),
                  ],
                ),
                child: ClipRSuperellipse(
                  borderRadius: Spacing.r8,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.d8,
                      vertical: Spacing.d4,
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Text(
                        widget.message,
                        maxLines: currentMaxTextLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          inherit: false,
                          color: currentFgColor,
                          fontSize: Spacing.d12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'system-ui',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    _entry = entry;
    overlay.insert(entry);
  }

  @override
  void didUpdateWidget(FluffyTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message.isEmpty && _entry != null) {
      _hide();
      return;
    }
    if (widget.message != oldWidget.message && _entry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _entry != null) {
          _entry?.markNeedsBuild();
        }
      });
    }
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.isEmpty) return widget.child;

    return MouseRegion(
      onEnter: _show,
      onExit: (_) => _hide(),
      child: widget.child,
    );
  }
}

class _TooltipLayoutDelegate extends SingleChildLayoutDelegate {
  const _TooltipLayoutDelegate({
    required this.targetRect,
    required this.margin,
  });

  final Rect targetRect;
  final double margin;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final maxAvailableWidth = math.max(
      Spacing.d0,
      constraints.maxWidth - margin * 2,
    );
    final maxWidth = math.min(Spacing.d320, maxAvailableWidth);
    final maxHeight = math.max(
      Spacing.d0,
      constraints.maxHeight - margin * 2,
    );
    return BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final maxX = math.max(margin, size.width - margin - childSize.width);
    final idealX = targetRect.center.dx - childSize.width / 2;
    final x = idealX.clamp(margin, maxX);

    final fitsAbove = targetRect.top - margin - childSize.height >= margin;
    final fitsBelow =
        targetRect.bottom + margin + childSize.height <= size.height - margin;
    final preferBelow = targetRect.center.dy <= size.height / 2;

    final showBelow = switch ((fitsAbove, fitsBelow)) {
      (true, true) => preferBelow,
      (false, true) => true,
      (true, false) => false,
      (false, false) => preferBelow,
    };

    final maxY = math.max(margin, size.height - margin - childSize.height);
    final idealY = switch (showBelow) {
      true => targetRect.bottom + margin,
      false => targetRect.top - margin - childSize.height,
    };
    final y = idealY.clamp(margin, maxY);

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_TooltipLayoutDelegate oldDelegate) {
    return targetRect != oldDelegate.targetRect || margin != oldDelegate.margin;
  }
}
