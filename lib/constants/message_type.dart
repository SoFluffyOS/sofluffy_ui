import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

enum MessageType {
  info,
  error,
  warning,
  success;

  Color get color {
    return switch (this) {
      MessageType.info => FluffyColors.info,
      MessageType.error => FluffyColors.error,
      MessageType.warning => FluffyColors.warningAlt,
      MessageType.success => FluffyColors.success,
    };
  }

  Widget get icon {
    final path = switch (this) {
      MessageType.info => FluffyAssets.icons.informationCircle,
      MessageType.error => FluffyAssets.icons.alertCircle,
      MessageType.warning => FluffyAssets.icons.alertCircle,
      MessageType.success => FluffyAssets.icons.informationCircle,
    };
    return ImageView(
      path,
      color: color,
      size: Spacing.d16,
      assetPackage: kSofluffyUiPackageName,
    );
  }
}
