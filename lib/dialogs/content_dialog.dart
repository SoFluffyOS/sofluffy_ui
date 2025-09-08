import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class ContentDialog {
  static Future<ConfirmAction> show(
    BuildContext context, {
    String? title,
    required String content,
    String? negativeText,
    String? positiveText,
    String? neutralText,
    bool useHtmlWidget = false,
  }) async {
    final controller = ScrollController();
    final result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: Scrollbar(
            controller: controller,
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (useHtmlWidget) HtmlWidget(content),
                  if (!useHtmlWidget) Text(content),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                if (negativeText case String negativeText)
                  Expanded(
                    child: Button(
                      tooltip: negativeText,
                      variant: ButtonVariant.ghost,
                      child: Flexible(
                        child: Text(
                          negativeText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onPressed: () {
                        context.navigator.pop(ConfirmAction.negative);
                      },
                    ),
                  ),
                if (negativeText != null && positiveText != null) Spacing.h8,
                if (positiveText case String positiveText)
                  Expanded(
                    child: Button(
                      tooltip: positiveText,
                      variant: ButtonVariant.primary,
                      child: Flexible(
                        child: Text(
                          positiveText,
                          style: TextStyle(
                            color: context.theme.colorScheme.onPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onPressed: () {
                        context.navigator.pop(ConfirmAction.positive);
                      },
                    ),
                  ),
              ],
            ),
            if (negativeText != null || positiveText != null) Spacing.v8,
            if (neutralText case String neutralText)
              Row(
                children: [
                  Expanded(
                    child: Button(
                      variant: ButtonVariant.primary,
                      tooltip: neutralText,
                      child: Flexible(
                        child: Text(
                          neutralText,
                          style: TextStyle(
                            color: context.theme.colorScheme.onPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    controller.dispose();

    if (result is! ConfirmAction) {
      return ConfirmAction.dismiss;
    }

    return result;
  }
}
