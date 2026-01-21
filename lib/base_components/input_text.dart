import 'package:design_system/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  /// Not allow updating.
  final FocusNode? focusNode;

  /// Not allow updating.
  final TextEditingController? controller;

  final String? label;
  final String? hintText;
  final String? errorText;

  final int? maxLength;

  final bool obscureText;
  final bool isPasswordField;
  final bool enableCounter;

  final String? prefixIcon;
  final String? suffixIcon;
  final VoidCallback? onSuffixTap;

  /// Only suffixIcon or suffix can be provide at a time.
  final Widget? suffix;

  final List<String>? autoFillHints;
  final TextInputType? keyboardType;

  const InputText({
    super.key,
    this.focusNode,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.onSuffixTap,
    this.obscureText = false,
    this.isPasswordField = false,
    this.enableCounter = false,
    this.autoFillHints,
    this.keyboardType,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  bool hasFocus = false;
  bool isHovering = false;

  bool get hasError => widget.errorText != null;
  late bool hasContent = _controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_controllerListener);
    _focusNode.addListener(_focusNodeListener);
  }

  void _controllerListener() {
    setState(() {
      hasContent = _controller.text.isNotEmpty;
    });
  }

  void _focusNodeListener() {
    setState(() {
      hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InputText oldWidget) {
    if (oldWidget.controller?.value != widget.controller?.value) {
      _controller.text = widget.controller?.text ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label case String label)
            Padding(
              padding: EdgeInsets.only(bottom: Spacing.d4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: ThemeConfigs().theme.typography.base2.copyWith(
                        color: _getLabelColor(context),
                      ),
                    ),
                  ),
                  if (widget.enableCounter) ...[
                    Spacing.h4,
                    Text(
                      '${_controller.text.length}'
                      '${widget.maxLength != null ? '/${widget.maxLength}' : ''}',
                      style: ThemeConfigs().theme.typography.caption2.copyWith(
                        color: ThemeConfigs().theme.colors.neutral4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          MouseRegion(
            onEnter: (_) {
              setState(() {
                isHovering = true;
              });
            },
            onExit: (_) {
              setState(() {
                isHovering = false;
              });
            },
            child: Container(
              decoration: ShapeDecoration(
                color: getBackgroundColor(context),
                shape: SmoothRectangleBorder(
                  borderRadius: Spacing.smoothR12,
                  side: BorderSide(color: getBorderColor(context), width: 2.0),
                ),
              ),
              child: CupertinoTextField(
                controller: _controller,
                focusNode: _focusNode,
                style: ThemeConfigs().theme.typography.base2.copyWith(
                  color: getTextColor(context),
                ),
                scrollPadding: EdgeInsets.zero,
                decoration: const BoxDecoration(),
                obscureText: widget.obscureText,
                autocorrect: !widget.isPasswordField,
                enableIMEPersonalizedLearning: !widget.isPasswordField,
                enableSuggestions: !widget.isPasswordField,
                enableInteractiveSelection: !widget.isPasswordField,
                autofillHints:
                    widget.isPasswordField
                        ? [AutofillHints.password]
                        : widget.autoFillHints,
                keyboardType:
                    widget.isPasswordField
                        ? TextInputType.visiblePassword
                        : widget.keyboardType,
                placeholder: widget.hintText,
                maxLength: widget.maxLength,
                placeholderStyle: ThemeConfigs().theme.typography.base2
                    .copyWith(
                      color: ThemeConfigs().theme.colors.neutral4.withValues(
                        alpha: 0.5,
                      ),
                    ),
                padding: EdgeInsets.only(
                  left: widget.prefixIcon == null ? Spacing.d16 : Spacing.d12,
                  right: Spacing.d16,
                  top: Spacing.d14,
                  bottom: Spacing.d14,
                ),
                prefix:
                    widget.prefixIcon == null
                        ? null
                        : Padding(
                          padding: EdgeInsets.only(left: Spacing.d16),
                          child: ImageView(
                            widget.prefixIcon,
                            size: Spacing.d24,
                            fit: BoxFit.contain,
                            color: getIconColor(context),
                          ),
                        ),
                suffix:
                    widget.suffix == null && widget.suffixIcon == null
                        ? null
                        : Padding(
                          padding: EdgeInsets.only(right: Spacing.d16),
                          child:
                              widget.suffix ??
                              Tappable(
                                onTap: widget.onSuffixTap,
                                child: ImageView(
                                  widget.suffixIcon,
                                  size: Spacing.d24,
                                  fit: BoxFit.contain,
                                  color: getIconColor(context),
                                ),
                              ),
                        ),
              ),
            ),
          ),
          if (widget.errorText case String error)
            Padding(
              padding: EdgeInsets.only(top: Spacing.d8),
              child: Text(
                error,
                style: ThemeConfigs().theme.typography.caption2.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color getBackgroundColor(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    if (hasFocus) {
      return isDark
          ? ThemeConfigs().theme.colors.neutral7
          : ThemeConfigs().theme.colors.neutral1;
    }

    return isDark
        ? ThemeConfigs().theme.colors.neutral6
        : ThemeConfigs().theme.colors.neutral2;
  }

  Color getIconColor(BuildContext context) {
    if (hasContent) {
      return ThemeConfigs().theme.colors.neutral4;
    }

    return ThemeConfigs().theme.colors.neutral4.withValues(alpha: 0.5);
  }

  Color getTextColor(BuildContext context) {
    if (isHovering) {
      return ThemeConfigs().theme.colors.primary;
    }

    if (hasError) {
      return Theme.of(context).colorScheme.error;
    }

    final isDark = context.theme.brightness == Brightness.dark;
    return isDark
        ? ThemeConfigs().theme.colors.neutral3
        : ThemeConfigs().theme.colors.neutral6;
  }

  Color getBorderColor(BuildContext context) {
    if (!hasFocus) {
      return getBackgroundColor(context);
    }
    final isDark = context.theme.brightness == Brightness.dark;
    return isDark
        ? ThemeConfigs().theme.colors.neutral5
        : ThemeConfigs().theme.colors.neutral2;
  }

  Color _getLabelColor(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    if (hasFocus) {
      return isDark
          ? ThemeConfigs().theme.colors.neutral1
          : ThemeConfigs().theme.colors.neutral7;
    }

    return ThemeConfigs().theme.colors.neutral4;
  }
}
