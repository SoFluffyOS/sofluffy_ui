import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final Widget child;

  final bool isExpanded;
  final Widget Function(bool isExpand)? toggleIconBuilder;
  final VoidCallback? onToggleExpand;

  const SideBar({
    super.key,
    required this.child,
    required this.isExpanded,
    this.toggleIconBuilder,
    this.onToggleExpand,
  });

  static double get sideBarWidth => Spacing.d280;

  static double get sideBarCollapsedWidth => Spacing.d96;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Durations.medium2,
      curve: Curves.easeOut,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: isExpanded ? sideBarWidth : sideBarCollapsedWidth,
        height: double.infinity,
        child: Stack(
          children: [
            if (toggleIconBuilder
                case Widget Function(bool isExpand) builder) ...[
              Positioned(
                right: 0,
                top: 0,
                child: Tappable(
                  onTap: () {
                    onToggleExpand?.call();
                  },
                  child: builder.call(isExpanded),
                ),
              ),
            ],
            Positioned.fill(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
