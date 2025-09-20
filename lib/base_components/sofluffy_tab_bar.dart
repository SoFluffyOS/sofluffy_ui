import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SoFluffyTab {
  final Widget icon;
  final Widget? selectedIcon;
  final String? title;
  final bool isClosable;

  const SoFluffyTab({
    required this.icon,
    this.selectedIcon,
    required this.title,
    this.isClosable = true,
  });
}

class SoFluffyTabBar extends StatelessWidget {
  final List<SoFluffyTab> items;

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int> onTabClose;

  final EdgeInsets? padding;

  final Color? selectedTabColor;
  final Color? unselectedTabColor;

  final Widget? tabDivider;

  const SoFluffyTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onTabClose,
    this.padding,
    this.selectedTabColor,
    this.unselectedTabColor,
    this.tabDivider,
  });

  static double get tabBarSize => Spacing.d32;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: tabBarSize,
      padding: padding,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          if (selectedIndex == index || index + 1 == selectedIndex) {
            return const SizedBox.shrink();
          }
          return tabDivider ?? const SizedBox.shrink();
        },
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final item = items[index];
          final title = item.title;
          final isClosable = item.isClosable;
          final selectedIcon = item.selectedIcon;
          final hasTitle = title != null && title.isNotEmpty;
          return Container(
            decoration: ShapeDecoration(
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(
                    cornerRadius: 12.0,
                    cornerSmoothing: 1.0,
                  ),
                  topRight: SmoothRadius(
                    cornerRadius: 12.0,
                    cornerSmoothing: 1.0,
                  ),
                ),
              ),
              color: isSelected
                  ? selectedTabColor ?? context.theme.scaffoldBackgroundColor
                  : unselectedTabColor ?? context.theme.cardColor,
            ),
            child: Tappable(
              behavior: HitTestBehavior.translucent,
              enableHover: true,
              onTap: () {
                onTabSelected(index);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.d12,
                ),
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  minWidth: tabBarSize,
                  minHeight: tabBarSize,
                ),
                height: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    switch (isSelected) {
                      true when selectedIcon != null => selectedIcon,
                      _ => item.icon,
                    },
                    if (hasTitle) ...[
                      SizedBox(width: Spacing.d8),
                      Text(
                        title,
                        style: context.theme.textTheme.bodyMedium,
                      ),
                    ],
                    if (isClosable) ...[
                      SizedBox(width: Spacing.d8),
                      Tappable(
                        behavior: HitTestBehavior.translucent,
                        enableHover: true,
                        onTap: () {
                          onTabClose(index);
                        },
                        child: Icon(
                          Icons.close,
                          color: context.theme.textTheme.bodyMedium?.color,
                          size: Spacing.d16,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
