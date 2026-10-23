import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

enum LoadingSpinnerSize { small, medium, large }

/// An indeterminate spinner in one of a few sizes, so loading states read
/// the same across the app.
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
      LoadingSpinnerSize.small => (Spacing.d10, 1.25),
      LoadingSpinnerSize.medium => (Spacing.d12, 1.5),
      LoadingSpinnerSize.large => (Spacing.d20, 2.0),
    };
    return SizedBox.square(
      dimension: dimension,
      child: FluffySpinner(strokeWidth: strokeWidth, color: color),
    );
  }
}
