import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

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

class BottomEmptyArea extends StatelessWidget {
  const BottomEmptyArea({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context).bottom;
    return SizedBox(height: padding + Spacing.d12 * 20);
  }
}
