import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';

class BottomSpacer extends StatelessWidget {
  const BottomSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context).bottom;
    if (padding <= 0.0) {
      return SizedBox(height: Spacing.d24);
    }
    return SizedBox(height: padding + Spacing.d24);
  }
}
