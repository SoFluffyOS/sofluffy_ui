import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class InputTextDialog {
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String labelText,
    String? hintText,
    required String cancelText,
    required String confirmText,
    String initialValue = '',
    String barrierLabel = 'Dismiss',
  }) async {
    // A prefilled value starts selected, so typing replaces it.
    final TextEditingController controller = TextEditingController.fromValue(
      TextEditingValue(
        text: initialValue,
        selection: TextSelection(
          baseOffset: 0,
          extentOffset: initialValue.length,
        ),
      ),
    );
    final focusNode = FocusNode(debugLabel: 'InputTextDialog');
    final fluffyTheme = context.fluffyTheme;

    try {
      final result = await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: barrierLabel,
        barrierColor: FluffyColors.barrier,
        transitionDuration: FluffyDurations.dialogTransition,
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        pageBuilder: (BuildContext context, anim1, anim2) {
          void confirm() {
            context.navigator.pop(controller.text);
          }

          final targetPlatform = fluffyTheme.platform ?? defaultTargetPlatform;
          final isDesktop = switch (targetPlatform) {
            TargetPlatform.macOS ||
            TargetPlatform.windows ||
            TargetPlatform.linux => true,
            _ => false,
          };

          final dialog = DialogCard(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AutofocusInput(
                  focusNode: focusNode,
                  child: InputText(
                    controller: controller,
                    focusNode: focusNode,
                    label: labelText,
                    hintText: hintText,
                    onSubmitted: (_) => confirm(),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: switch (isDesktop) {
                  true => MainAxisAlignment.end,
                  false => MainAxisAlignment.center,
                },
                children: switch (isDesktop) {
                  true => [
                    Button(
                      variant: ButtonVariant.ghost,
                      tooltip: cancelText,
                      label: cancelText,
                      mainAxisSize: MainAxisSize.min,
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.d16,
                        vertical: Spacing.d8,
                      ),
                      onPressed: () {
                        context.navigator.pop();
                      },
                    ),
                    Spacing.h8,
                    Button(
                      variant: ButtonVariant.primary,
                      tooltip: confirmText,
                      label: confirmText,
                      mainAxisSize: MainAxisSize.min,
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.d16,
                        vertical: Spacing.d8,
                      ),
                      onPressed: confirm,
                    ),
                  ],
                  false => [
                    Expanded(
                      child: Button(
                        variant: ButtonVariant.ghost,
                        tooltip: cancelText,
                        label: cancelText,
                        titleExpand: ButtonTitleExpand.shrink,
                        onPressed: () {
                          context.navigator.pop();
                        },
                      ),
                    ),
                    Spacing.h8,
                    Expanded(
                      child: Button(
                        variant: ButtonVariant.primary,
                        tooltip: confirmText,
                        label: confirmText,
                        titleExpand: ButtonTitleExpand.shrink,
                        onPressed: confirm,
                      ),
                    ),
                  ],
                },
              ),
            ],
          );

          return FluffyTheme(
            data: fluffyTheme,
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter): confirm,
                const SingleActivator(LogicalKeyboardKey.numpadEnter): confirm,
              },
              child: dialog,
            ),
          );
        },
      );

      if (result is! String) {
        return null;
      }

      return result;
    } finally {
      controller.dispose();
      focusNode.dispose();
    }
  }
}

/// Puts the cursor in the dialog's field when it opens, so the user can
/// type straight away.
class _AutofocusInput extends StatefulWidget {
  const _AutofocusInput({required this.focusNode, required this.child});

  final FocusNode focusNode;
  final Widget child;

  @override
  State<_AutofocusInput> createState() => _AutofocusInputState();
}

class _AutofocusInputState extends State<_AutofocusInput> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
