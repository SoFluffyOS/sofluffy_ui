import 'dart:async';

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

enum _TooltipHorizontalAlignment { left, center, right }

class _FluffyTooltipState extends State<FluffyTooltip> {
  final _controller = OverlayPortalController();
  final _link = LayerLink();
  final _surfaceKey = GlobalKey();
  Timer? _showTimer;
  Rect? _targetRect;
  Size? _tooltipSize;
  bool _showAbove = false;
  _TooltipHorizontalAlignment _horizontalAlignment =
      _TooltipHorizontalAlignment.center;

  void _show(PointerEnterEvent event) {
    final windowSize = MediaQuery.sizeOf(context);
    final windowHeight = windowSize.height;
    final targetRect = _resolveTargetRect();
    final targetCenterY = targetRect?.center.dy ?? event.position.dy;
    final showAbove = targetCenterY > windowHeight / 2;
    final horizontalAlignment = _resolveHorizontalAlignment(
      pointerX: event.position.dx,
      windowWidth: windowSize.width,
    );
    _targetRect = targetRect;
    if (_showAbove != showAbove ||
        _horizontalAlignment != horizontalAlignment) {
      setState(() {
        _showAbove = showAbove;
        _horizontalAlignment = horizontalAlignment;
      });
    }
    _showTimer?.cancel();
    _showTimer = Timer(FluffyDurations.tooltip, _showTooltip);
  }

  Rect? _resolveTargetRect() {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  void _showTooltip() {
    if (!mounted) return;
    _controller.show();
    _scheduleMeasurement();
  }

  void _scheduleMeasurement() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.isShowing) return;
      final renderObject = _surfaceKey.currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) return;
      final targetRect = _resolveTargetRect();
      final windowSize = MediaQuery.sizeOf(context);
      final horizontalAlignment = _resolveHorizontalAlignment(
        pointerX: targetRect?.center.dx ?? windowSize.width / 2,
        windowWidth: windowSize.width,
      );
      final showAbove = switch (targetRect) {
        final rect? => rect.center.dy > windowSize.height / 2,
        null => _showAbove,
      };
      if (_tooltipSize == renderObject.size &&
          _targetRect == targetRect &&
          _horizontalAlignment == horizontalAlignment &&
          _showAbove == showAbove) {
        return;
      }
      setState(() {
        _tooltipSize = renderObject.size;
        _targetRect = targetRect;
        _horizontalAlignment = horizontalAlignment;
        _showAbove = showAbove;
      });
    });
  }

  _TooltipHorizontalAlignment _resolveHorizontalAlignment({
    required double pointerX,
    required double windowWidth,
  }) {
    final edgeThreshold = Spacing.d320 / 2 + Spacing.d8;
    if (pointerX < edgeThreshold) return _TooltipHorizontalAlignment.left;
    if (pointerX > windowWidth - edgeThreshold) {
      return _TooltipHorizontalAlignment.right;
    }
    return _TooltipHorizontalAlignment.center;
  }

  Alignment get _targetAnchor {
    return switch ((_showAbove, _horizontalAlignment)) {
      (true, _TooltipHorizontalAlignment.left) => Alignment.topLeft,
      (true, _TooltipHorizontalAlignment.center) => Alignment.topCenter,
      (true, _TooltipHorizontalAlignment.right) => Alignment.topRight,
      (false, _TooltipHorizontalAlignment.left) => Alignment.bottomLeft,
      (false, _TooltipHorizontalAlignment.center) => Alignment.bottomCenter,
      (false, _TooltipHorizontalAlignment.right) => Alignment.bottomRight,
    };
  }

  Alignment get _followerAnchor {
    return switch ((_showAbove, _horizontalAlignment)) {
      (true, _TooltipHorizontalAlignment.left) => Alignment.bottomLeft,
      (true, _TooltipHorizontalAlignment.center) => Alignment.bottomCenter,
      (true, _TooltipHorizontalAlignment.right) => Alignment.bottomRight,
      (false, _TooltipHorizontalAlignment.left) => Alignment.topLeft,
      (false, _TooltipHorizontalAlignment.center) => Alignment.topCenter,
      (false, _TooltipHorizontalAlignment.right) => Alignment.topRight,
    };
  }

  void _hide() {
    _showTimer?.cancel();
    _controller.hide();
  }

  double _verticalCorrection(double windowHeight) {
    final targetRect = _targetRect;
    final tooltipSize = _tooltipSize;
    if (targetRect == null || tooltipSize == null) return 0;

    final tooltipTop = switch (_showAbove) {
      true => targetRect.top - Spacing.d8 - tooltipSize.height,
      false => targetRect.bottom + Spacing.d8,
    };
    final tooltipBottom = tooltipTop + tooltipSize.height;
    if (tooltipTop < Spacing.d8) return Spacing.d8 - tooltipTop;
    if (tooltipBottom > windowHeight - Spacing.d8) {
      return windowHeight - Spacing.d8 - tooltipBottom;
    }
    return 0;
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isShowing) _scheduleMeasurement();
    final theme = context.fluffyTheme;
    final windowSize = MediaQuery.sizeOf(context);
    final availableWidth = windowSize.width - Spacing.d16;
    final availableHeight = windowSize.height - Spacing.d16;
    final maxTooltipWidth = switch (availableWidth < Spacing.d320) {
      true => availableWidth,
      false => Spacing.d320,
    };
    final maxTooltipHeight = switch (availableHeight > 0) {
      true => availableHeight,
      false => 0.0,
    };
    final maxTextLines = switch (((maxTooltipHeight - Spacing.d8) / Spacing.d16)
        .floor()) {
      < 1 => 1,
      final lineCount => lineCount,
    };
    final backgroundColor = switch (theme.isDark) {
      true => theme.colors.neutral6,
      false => theme.colors.neutral2,
    };
    final textColor = switch (theme.isDark) {
      true => theme.colors.neutral2,
      false => theme.colors.neutral6,
    };
    final borderColor = switch (theme.isDark) {
      true => theme.colors.neutral5,
      false => theme.colors.neutral3,
    };

    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (context) {
        return UnconstrainedBox(
          alignment: Alignment.topLeft,
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: _targetAnchor,
            followerAnchor: _followerAnchor,
            offset: Offset(
              switch (_horizontalAlignment) {
                _TooltipHorizontalAlignment.left => Spacing.d8,
                _TooltipHorizontalAlignment.center => 0,
                _TooltipHorizontalAlignment.right => -Spacing.d8,
              },
              switch (_showAbove) {
                true => -Spacing.d8 + _verticalCorrection(windowSize.height),
                false => Spacing.d8 + _verticalCorrection(windowSize.height),
              },
            ),
            child: IgnorePointer(
              child: ConstrainedBox(
                key: const ValueKey('fluffy-tooltip-surface'),
                constraints: BoxConstraints(
                  maxWidth: maxTooltipWidth,
                  maxHeight: maxTooltipHeight,
                ),
                child: DecoratedBox(
                  key: _surfaceKey,
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
                        color: FluffyColors.shadowMedium,
                        blurRadius: Spacing.d12,
                        offset: Offset(0, Spacing.d4),
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
                      child: Text(
                        widget.message,
                        maxLines: maxTextLines,
                        overflow: TextOverflow.ellipsis,
                        style: theme.typography.caption1.copyWith(
                          color: textColor,
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
      child: CompositedTransformTarget(
        link: _link,
        child: MouseRegion(
          onEnter: _show,
          onExit: (_) => _hide(),
          child: widget.child,
        ),
      ),
    );
  }
}
