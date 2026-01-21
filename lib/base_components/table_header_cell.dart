import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class TableHeaderCell extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool sortAscending;
  final bool isSorted;

  const TableHeaderCell(
    this.text, {
    this.onTap,
    this.sortAscending = true,
    this.isSorted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: Spacing.d24,
          right: Spacing.d8,
          top: Spacing.d8,
          bottom: Spacing.d8,
        ),
        child: Row(
          children: [
            Text(
              text,
              style: ThemeConfigs().theme.typography.base1,
            ),
            if (isSorted) ...[
              Spacing.h4,
              Icon(
                sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: ThemeConfigs().theme.typography.base1.color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
