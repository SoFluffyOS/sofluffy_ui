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
      MessageType.info =>
        Assets.hugeicons.stroke.alertNotification.informationCircle,
      MessageType.error =>
        Assets.hugeicons.stroke.alertNotification.alertCircle,
      MessageType.warning =>
        Assets.hugeicons.stroke.alertNotification.alertCircle,
      MessageType.success =>
        Assets.hugeicons.stroke.alertNotification.informationCircle,
    };
    return ImageView(
      path,
      color: color,
      size: Spacing.d16,
    );
  }
}
