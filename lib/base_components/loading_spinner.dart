import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

enum LoadingSpinnerSize { small, medium, large }

/// An indeterminate spinner in one of a few sizes, so loading states read
/// the same across the app: [LoadingSpinnerSize.medium] sits beside small
/// text, as in a status bar, with a stroke about as heavy as the letters.
class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    super.key,
    this.size = LoadingSpinnerSize.medium,
    this.color,
  });

  final LoadingSpinnerSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final (dimension, strokeWidth) = switch (size) {
      LoadingSpinnerSize.small => (Spacing.d10, Spacing.d1 + Spacing.d0),
      LoadingSpinnerSize.medium => (Spacing.d12, Spacing.d2),
      LoadingSpinnerSize.large => (Spacing.d20, Spacing.d2),
    };

    return FluffySpinner(
      size: dimension,
      strokeWidth: strokeWidth,
      color: color,
    );
  }
}
