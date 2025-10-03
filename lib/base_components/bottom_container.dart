import 'package:design_system/design_system.dart'
    show
        AfterLayoutMixin,
        Spacing,
        BuildContextExtension,
        SmoothRectangleBorder,
        SmoothBorderRadius,
        SmoothRadius;
import 'package:flutter/material.dart';

class BottomContainer extends StatefulWidget {
  final Widget child;

  final Color? color;

  final ScrollController? scrollController;

  const BottomContainer({
    super.key,
    required this.child,
    this.color,
    this.scrollController,
  });

  @override
  State<BottomContainer> createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer>
    with AfterLayoutMixin {
  late ScrollController? _scrollController = widget.scrollController;

  bool _shouldShowShadow = true;

  void _updateShadowVisibility() {
    final controller = _scrollController;
    if (controller != null && controller.hasClients && mounted) {
      final maxValue = controller.position.maxScrollExtent;
      _shouldShowShadow = controller.position.pixels < maxValue;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController?.addListener(_updateShadowVisibility);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _updateShadowVisibility();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_updateShadowVisibility);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BottomContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      _scrollController?.removeListener(_updateShadowVisibility);
      _scrollController = widget.scrollController;
      _scrollController?.addListener(_updateShadowVisibility);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: ShapeDecoration(
        color: widget.color ?? Colors.white,
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.vertical(
            top: SmoothRadius(
              cornerRadius: 16.0,
              cornerSmoothing: 1.0,
            ),
          ),
        ),
        shadows: switch (_shouldShowShadow) {
          true => [
            BoxShadow(
              color: context.theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: Spacing.d4,
              offset: const Offset(0.0, -2.0),
            ),
          ],
          false => null,
        },
      ),
      padding: EdgeInsets.only(
        left: Spacing.d16,
        right: Spacing.d16,
        top: Spacing.d16,
        bottom: Spacing.d16,
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: SizedBox(
          width: double.infinity,
          child: widget.child,
        ),
      ),
    );
  }
}
