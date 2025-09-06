import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum MessageType {
  info,
  error,
  warning,
  success;

  Color get color {
    return switch (this) {
      MessageType.info => Colors.blue,
      MessageType.error => Colors.red,
      MessageType.warning => Colors.yellow,
      MessageType.success => Colors.green,
    };
  }

  Widget get icon {
    final path = switch (this) {
      MessageType.info => DesignSystemAssets.icons.informationCircle,
      MessageType.error => DesignSystemAssets.icons.alertCircle,
      MessageType.warning => DesignSystemAssets.icons.alertCircle,
      MessageType.success => DesignSystemAssets.icons.informationCircle,
    };
    return ImageView(
      path,
      color: color,
      size: Spacing.d16,
      assetPackage: kDesignSystemPackageName,
    );
  }
}
