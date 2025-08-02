import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  void toast(
    dynamic message, {
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(message, type: type, duration: duration);
  }

  Future<void> showToast(
    dynamic message, {
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    Function? onActionTap,
  }) async {
    unawaited(HapticFeedback.lightImpact());
    bool isLoading = false;
    try {
      return await showFlash(
        context: this,
        duration: duration,
        barrierDismissible: true,
        builder: (context, controller) {
          return FlashBar(
            controller: controller,
            shouldIconPulse: true,
            position: FlashPosition.top,
            behavior: FlashBehavior.floating,
            padding: EdgeInsets.zero,
            content: Container(
              decoration: ShapeDecoration(
                color: type.color.withValues(alpha: 0.05),
                shape: SmoothRectangleBorder(
                  borderRadius: const SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 12.0,
                      cornerSmoothing: 1.0,
                    ),
                  ),
                  side: BorderSide(
                    color: type.color,
                    width: Spacing.d1,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Spacing.h16,
                  type.icon,
                  Spacing.h8,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Spacing.d16,
                      ),
                      child: Text(
                        '$message',
                        style: TextStyle(
                          color: type.color,
                        ),
                      ),
                    ),
                  ),
                  Spacing.h16,
                ],
              ),
            ),
            primaryAction: actionLabel != null
                ? Tappable(
                    onTap: isLoading
                        ? null
                        : () async {
                            // TODO: update.
                            // setState(() {
                            //   isLoading = true;
                            // });
                            await onActionTap?.call();
                            await controller.dismiss();
                          },
                    child: Padding(
                      padding: EdgeInsets.all(Spacing.d16),
                      child: Text(
                        actionLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      );
    } catch (_) {}
  }
}
