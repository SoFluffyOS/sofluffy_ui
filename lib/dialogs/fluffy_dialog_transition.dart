import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

/// How a dialog appears: fading in as it grows from 95%, or only fading in
/// when motion is reduced.
class FluffyDialogTransition extends StatelessWidget {
  const FluffyDialogTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: switch (context.reducesMotion) {
          true => kAlwaysCompleteAnimation,
          false => Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
        },
        child: child,
      ),
    );
  }
}
