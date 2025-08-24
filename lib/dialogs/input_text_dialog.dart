import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class InputTextDialog {
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String labelText,
    String? hintText,
    required String cancelText,
    required String confirmText,
    String initialValue = '',
  }) async {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputText(
                controller: controller,
                label: labelText,
                hintText: hintText,
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Button(
                    variant: ButtonVariant.ghost,
                    child: Text(cancelText),
                    onPressed: () {
                      context.navigator.pop();
                    },
                  ),
                ),
                Spacing.h8,
                Expanded(
                  child: Button(
                    variant: ButtonVariant.primary,
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () {
                      context.navigator.pop(controller.text);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result is! String) {
      return null;
    }

    return result;
  }
}
