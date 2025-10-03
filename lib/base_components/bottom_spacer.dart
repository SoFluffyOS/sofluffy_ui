import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';

class BottomSpacer extends StatelessWidget {
  const BottomSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context).bottom;
    return SizedBox(height: padding + Spacing.d12 * 20);
  }
}
