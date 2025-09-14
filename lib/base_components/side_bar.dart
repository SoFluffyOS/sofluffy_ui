import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  final Widget child;

  final Widget Function(bool isExpand)? toggleIconBuilder;

  const SideBar({
    super.key,
    required this.child,
    this.toggleIconBuilder,
  });

  static double get sideBarWidth => Spacing.d280;

  static double get sideBarCollapsedWidth => Spacing.d96;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Durations.medium2,
      curve: Curves.easeOut,
      alignment: Alignment.centerLeft,
      child: ValueListenableBuilder(
        valueListenable: _isExpandedNotifier,
        builder: (context, isExpanded, child) {
          return SizedBox(
            width: isExpanded
                ? SideBar.sideBarWidth
                : SideBar.sideBarCollapsedWidth,
            height: double.infinity,
            child: Stack(
              children: [
                if (widget.toggleIconBuilder
                    case Widget Function(bool isExpand) builder) ...[
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Tappable(
                      onTap: () {
                        _isExpandedNotifier.value = !isExpanded;
                      },
                      child: builder.call(isExpanded),
                    ),
                  ),
                ],
                Positioned.fill(
                  child: widget.child,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
