import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

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

class SoSoFluffyTabBar extends StatelessWidget {
  final List<SoFluffyTab> items;

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int> onTabClose;

  final EdgeInsets? padding;

  final Color? selectedTabColor;
  final Color? unselectedTabColor;

  final Widget? tabDivider;

  const SoSoFluffyTabBar({
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
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final defaultSelectedColor = isDark
        ? theme.colors.neutral7
        : theme.colors.neutral1;
    final defaultUnselectedColor = isDark
        ? theme.colors.neutral6
        : theme.colors.neutral2;

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
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Spacing.d12),
                  topRight: Radius.circular(Spacing.d12),
                ),
              ),
              color: isSelected
                  ? selectedTabColor ?? defaultSelectedColor
                  : unselectedTabColor ?? defaultUnselectedColor,
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
                        style: theme.typography.base2,
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
                        child: _CloseIcon(
                          color: isDark
                              ? theme.colors.neutral1
                              : theme.colors.neutral7,
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

class _CloseIcon extends StatelessWidget {
  final Color color;
  final double size;

  const _CloseIcon({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CloseIconPainter(color),
      ),
    );
  }
}

class _CloseIconPainter extends CustomPainter {
  final Color color;

  _CloseIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    const padding = 3.0;
    canvas.drawLine(
      const Offset(padding, padding),
      Offset(size.width - padding, size.height - padding),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(padding, size.height - padding),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CloseIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
