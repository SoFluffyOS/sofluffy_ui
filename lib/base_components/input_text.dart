import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

part 'input_text_context_menu.dart';

typedef DecorationBuilder =
    Decoration Function(
      BuildContext context,
      bool isHovering,
      bool hasContent,
      bool hasFocus,
    );

class InputText extends StatefulWidget {
  /// Not allow updating.
  final FocusNode? focusNode;

  /// Not allow updating.
  final TextEditingController? controller;

  final String? label;
  final String? hintText;
  final String? errorText;

  final int? maxLength;
  final int? maxLines;

  final bool obscureText;
  final bool isPasswordField;
  final bool enableCounter;

  /// When true, the text field is not editable.
  final bool readOnly;

  final String? prefixIcon;
  final String? suffixIcon;
  final VoidCallback? onSuffixTap;

  /// Only prefixIcon or prefix can be provide at a time.
  final Widget? prefix;

  /// Only suffixIcon or suffix can be provide at a time.
  final Widget? suffix;

  final List<String>? autoFillHints;
  final TextInputType? keyboardType;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;

  final DecorationBuilder? decorationBuilder;
  final TextStyle? textStyle;

  final EdgeInsetsGeometry? inputPadding;
  final double? cursorHeight;
  final double cursorWidth;

  final double? borderRadius;

  const InputText({
    super.key,
    this.focusNode,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.isPasswordField = false,
    this.enableCounter = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.prefix,
    this.suffix,
    this.autoFillHints,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction,
    this.decorationBuilder,
    this.textStyle,
    this.inputPadding,
    this.cursorHeight,
    this.cursorWidth = 2.0,
    this.borderRadius,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText>
    implements TextSelectionGestureDetectorBuilderDelegate {
  final GlobalKey<EditableTextState> _editableTextKey =
      GlobalKey<EditableTextState>();

  late final TextSelectionGestureDetectorBuilder _selectionGestureBuilder =
      TextSelectionGestureDetectorBuilder(delegate: this);

  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  bool hasFocus = false;
  bool isHovering = false;

  bool get hasError => widget.errorText != null;
  late bool hasContent = _controller.text.isNotEmpty;

  @override
  GlobalKey<EditableTextState> get editableTextKey => _editableTextKey;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => switch (widget.isPasswordField) {
    true => false,
    false => true,
  };

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
    if (widget.controller case final controller?
        when controller.text != _controller.text) {
      _controller.text = controller.text;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final isDesktop = switch (defaultTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };
    final baseTextStyle =
        widget.textStyle ??
        (isDesktop ? theme.typography.caption1 : theme.typography.base2);
    final textStyle = baseTextStyle.copyWith(
      color: getTextColor(context),
    );
    final placeholderStyle = baseTextStyle.copyWith(
      color: theme.colors.neutral4.withValues(alpha: 0.5),
    );

    final resolvedPadding =
        widget.inputPadding ??
        (isDesktop
            ? EdgeInsets.only(
                left: widget.prefixIcon == null && widget.prefix == null
                    ? Spacing.d12
                    : Spacing.d8,
                right: Spacing.d12,
                top: Spacing.d8,
                bottom: Spacing.d8,
              )
            : EdgeInsets.only(
                left: widget.prefixIcon == null && widget.prefix == null
                    ? Spacing.d16
                    : Spacing.d12,
                right: Spacing.d16,
                top: Spacing.d14,
                bottom: Spacing.d14,
              ));

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label case String label)
            Padding(
              padding: EdgeInsets.only(bottom: Spacing.d4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: baseTextStyle.copyWith(
                        color: _getLabelColor(context),
                      ),
                    ),
                  ),
                  if (widget.enableCounter) ...[
                    Spacing.h4,
                    Text(
                      '${_controller.text.length}'
                      '${widget.maxLength != null ? '/${widget.maxLength}' : ''}',
                      style: theme.typography.caption2.copyWith(
                        color: theme.colors.neutral4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          Flexible(
            child: MouseRegion(
              cursor: SystemMouseCursors.text,
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
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _focusNode.requestFocus(),
                child: Container(
                  decoration:
                      widget.decorationBuilder?.call(
                        context,
                        isHovering,
                        hasContent,
                        hasFocus,
                      ) ??
                      ShapeDecoration(
                        color: getBackgroundColor(context),
                        shape: RoundedSuperellipseBorder(
                          borderRadius: switch (widget.borderRadius) {
                            final borderRadius? => BorderRadius.all(
                              Radius.circular(borderRadius),
                            ),
                            _ => Spacing.r12,
                          },
                          side: BorderSide(
                            color: getBorderColor(context),
                            width: 2.0,
                          ),
                        ),
                      ),
                  padding: resolvedPadding,
                  child: Row(
                    children: [
                      if (widget.prefix != null || widget.prefixIcon != null)
                        Padding(
                          padding: EdgeInsets.only(right: Spacing.d8),
                          child:
                              widget.prefix ??
                              ImageView(
                                widget.prefixIcon,
                                size: isDesktop ? Spacing.d18 : Spacing.d24,
                                fit: BoxFit.contain,
                                color: getIconColor(context),
                              ),
                        ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            if (_controller.text.isEmpty &&
                                widget.hintText != null)
                              IgnorePointer(
                                child: Text(
                                  widget.hintText!,
                                  style: placeholderStyle,
                                  maxLines: widget.maxLines,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            _selectionGestureBuilder.buildGestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: EditableText(
                                key: _editableTextKey,
                                controller: _controller,
                                focusNode: _focusNode,
                                style: textStyle,
                                cursorColor: theme.colors.primary,
                                selectionColor: theme.colors.primary.withValues(
                                  alpha: 0.3,
                                ),
                                backgroundCursorColor: isDark
                                    ? theme.colors.neutral5
                                    : theme.colors.neutral3,
                                cursorHeight: widget.cursorHeight,
                                cursorWidth: widget.cursorWidth,
                                obscureText: widget.obscureText,
                                autocorrect: !widget.isPasswordField,
                                enableIMEPersonalizedLearning:
                                    switch (widget.isPasswordField) {
                                      true => false,
                                      false => true,
                                    },
                                enableSuggestions: !widget.isPasswordField,
                                enableInteractiveSelection: selectionEnabled,
                                autofillHints: widget.isPasswordField
                                    ? [AutofillHints.password]
                                    : widget.autoFillHints,
                                keyboardType: widget.isPasswordField
                                    ? TextInputType.visiblePassword
                                    : widget.keyboardType,
                                inputFormatters: [
                                  if (widget.maxLength != null)
                                    LengthLimitingTextInputFormatter(
                                      widget.maxLength,
                                    ),
                                ],
                                maxLines: widget.maxLines,
                                readOnly: widget.readOnly,
                                rendererIgnoresPointer: true,
                                contextMenuBuilder:
                                    (context, editableTextState) {
                                      return _InputTextContextMenu(
                                        theme: theme,
                                        anchors: editableTextState
                                            .contextMenuAnchors,
                                        buttonItems: editableTextState
                                            .contextMenuButtonItems,
                                      );
                                    },
                                onChanged: widget.onChanged,
                                onSubmitted: widget.onSubmitted,
                                onEditingComplete: widget.onEditingComplete,
                                textInputAction: widget.textInputAction,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.suffix != null || widget.suffixIcon != null)
                        Padding(
                          padding: EdgeInsets.only(left: Spacing.d8),
                          child:
                              widget.suffix ??
                              Tappable(
                                onTap: widget.onSuffixTap,
                                child: ImageView(
                                  widget.suffixIcon,
                                  size: isDesktop ? Spacing.d18 : Spacing.d24,
                                  fit: BoxFit.contain,
                                  color: getIconColor(context),
                                ),
                              ),
                        ),
                    ],
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
                style: theme.typography.caption2.copyWith(
                  color: FluffyColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color getBackgroundColor(BuildContext context) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    if (hasFocus) {
      return isDark ? theme.colors.neutral7 : theme.colors.neutral1;
    }

    return isDark ? theme.colors.neutral6 : theme.colors.neutral2;
  }

  Color getIconColor(BuildContext context) {
    final theme = context.fluffyTheme;
    if (hasContent) {
      return theme.colors.neutral4;
    }

    return theme.colors.neutral4.withValues(alpha: 0.5);
  }

  Color getTextColor(BuildContext context) {
    final theme = context.fluffyTheme;
    if (isHovering) {
      return theme.colors.primary;
    }

    if (hasError) {
      return FluffyColors.error;
    }

    final isDark = context.isDark;
    return isDark ? theme.colors.neutral1 : theme.colors.neutral6;
  }

  Color getBorderColor(BuildContext context) {
    if (!hasFocus) {
      return getBackgroundColor(context);
    }
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    return isDark ? theme.colors.neutral5 : theme.colors.neutral2;
  }

  Color _getLabelColor(BuildContext context) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    if (hasFocus) {
      return isDark ? theme.colors.neutral1 : theme.colors.neutral7;
    }

    return theme.colors.neutral4;
  }
}
