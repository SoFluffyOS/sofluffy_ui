import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

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
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: ShapeDecoration(
        color:
            widget.color ??
            (isDark ? theme.colors.neutral6 : theme.colors.neutral1),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Spacing.d16),
          ),
        ),
        shadows: switch (_shouldShowShadow) {
          true => [
            BoxShadow(
              color: FluffyColors.shadowLight,
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
