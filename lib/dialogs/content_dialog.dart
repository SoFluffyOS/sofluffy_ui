import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class ContentDialog {
  static Future<void> show(
    BuildContext context, {
    String? title,
    required String content,
    required String closeText,
    bool useHtmlWidget = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (useHtmlWidget) HtmlWidget(content),
                if (!useHtmlWidget) Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Button(
                    variant: ButtonVariant.primary,
                    child: Text(
                      closeText,
                      style: TextStyle(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () {
                      context.navigator.pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
