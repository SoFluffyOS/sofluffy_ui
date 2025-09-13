import 'package:flutter/widgets.dart';

class DisableWidget extends StatelessWidget {
  final Widget child;
  final bool disabled;

  const DisableWidget({
    super.key,
    required this.child,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      return FocusScope(
        canRequestFocus: false,
        child: IgnorePointer(
          child: Opacity(
            opacity: 0.2,
            child: child,
          ),
        ),
      );
    }
    return child;
  }
}
