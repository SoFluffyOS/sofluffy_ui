import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class TableBodyCell extends StatelessWidget {
  final Widget child;

  const TableBodyCell({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Spacing.d24,
        right: Spacing.d8,
        top: Spacing.d4,
        bottom: Spacing.d4,
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
