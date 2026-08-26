/// Common static durations used across Fluffy UI.
///
/// Named [FluffyDurations] (plural) to avoid conflicts with Material's `Durations` class.
class FluffyDurations {
  const FluffyDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);

  // Component-specific durations
  static const Duration dialogTransition = Duration(milliseconds: 150);
  static const Duration buttonPress = Duration(milliseconds: 150);
  static const Duration toggle = Duration(milliseconds: 200);
  static const Duration debounce = Duration(milliseconds: 500);
  static const Duration tooltip = Duration(milliseconds: 300);
}
