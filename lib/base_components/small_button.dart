part of 'buttons.dart';

class SmallButton extends StatefulWidget {
  final ButtonVariant variant;

  final Function? onPressed;

  final String? label;

  final Widget? icon;
  final Widget? child;
  final Widget? trailingIcon;

  final Color? color;

  final bool enable;
  final bool enableHover;

  final ButtonTitleExpand titleExpand;

  final String? tooltip;
  final String? semanticLabel;

  final double? width;
  final double? height;
  final double? borderWidth;
  final double? radius;

  final EdgeInsets? padding;

  final MainAxisSize? mainAxisSize;
  final MainAxisAlignment? mainAxisAlignment;

  final TextAlign? labelTextAlign;

  const SmallButton({
    super.key,
    required this.variant,
    this.label,
    this.icon,
    this.trailingIcon,
    this.color,
    this.tooltip,
    this.enable = true,
    this.enableHover = true,
    this.titleExpand = ButtonTitleExpand.none,
    this.onPressed,
    this.child,
    this.semanticLabel,
    this.width,
    this.height,
    this.borderWidth,
    this.radius,
    this.padding,
    this.mainAxisSize,
    this.mainAxisAlignment,
    this.labelTextAlign,
  }) : assert(
         (label != null && child == null) || (label == null && child != null),
         'Either label or child must be provided',
       );

  @override
  State<SmallButton> createState() => _SmallButtonState();
}

class _SmallButtonState extends State<SmallButton> {
  late final ValueNotifier<ButtonState> stateNotifier = ValueNotifier(
    widget.enable ? ButtonState.normal : ButtonState.disabled,
  );

  @override
  void didUpdateWidget(covariant SmallButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enable != oldWidget.enable) {
      stateNotifier.value = widget.enable
          ? ButtonState.normal
          : ButtonState.disabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    late final Widget child;
    if (widget.child case Widget thisChild) {
      child = thisChild;
    } else if (widget.label case String label) {
      child = Text(
        label,
        style: context.themeConfigs.typography.caption1.copyWith(
          color: widget.variant.getForegroundColor(
            context,
            stateNotifier.value,
            widget.color,
          ),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: widget.labelTextAlign ?? TextAlign.center,
      );
    }
    return Semantics(
      label: widget.semanticLabel ?? widget.tooltip,
      button: true,
      enabled: widget.enable,
      child: ValueListenableBuilder(
        valueListenable: stateNotifier,
        builder: (context, state, _) {
          return Tappable(
            onStateChanged: (newState) {
              if (!widget.enable) {
                stateNotifier.value = ButtonState.disabled;
                return;
              }
              switch (newState) {
                case TappableState.normal:
                  stateNotifier.value = ButtonState.normal;
                  break;
                case TappableState.hover:
                  stateNotifier.value = ButtonState.hover;
                  break;
                case TappableState.focus:
                  stateNotifier.value = ButtonState.focus;
                  break;
                case TappableState.pressed:
                  stateNotifier.value = ButtonState.pressing;
                  break;
              }
            },
            enableAnimation: true,
            enableHoverOverlay: false,
            enableFocusBorder: false,
            tooltip: widget.tooltip,
            onTap: widget.enable
                ? () {
                    HapticFeedback.lightImpact();
                    widget.onPressed?.call();
                  }
                : null,
            enableHover: widget.enableHover,
            // SmallButton: Reduced default radius to d8 (8.0)
            hoverOverlayBorderRadius: widget.radius ?? Spacing.d8,
            hoverOverlayColorTint:
                widget.color ??
                widget.variant.getBackgroundColor(context, state, widget.color),
            child: Builder(
              builder: (context) {
                return AnimatedContainer(
                  width: widget.width,
                  height: widget.height,
                  duration: Durations.medium4,
                  curve: Curves.easeOut,
                  padding:
                      widget.padding ??
                      EdgeInsets.symmetric(
                        horizontal: Spacing.d12,
                        vertical: Spacing.d8,
                      ),
                  decoration: ShapeDecoration(
                    color: widget.variant.getBackgroundColor(
                      context,
                      state,
                      widget.color,
                    ),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(
                        SmoothRadius(
                          cornerRadius: widget.radius ?? 8.0,
                          cornerSmoothing: 1.0,
                        ),
                      ),
                      side: BorderSide(
                        color:
                            widget.variant.getBorderColor(
                              context,
                              state,
                              widget.color,
                            ) ??
                            Colors.transparent,
                        width: widget.borderWidth ?? Spacing.d2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
                    mainAxisAlignment:
                        widget.mainAxisAlignment ?? MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.icon != null) widget.icon!,
                      if (widget.icon != null) SizedBox(width: Spacing.d8),
                      switch (widget.titleExpand) {
                        ButtonTitleExpand.shrink => Flexible(child: child),
                        ButtonTitleExpand.expand => Expanded(child: child),
                        ButtonTitleExpand.none => child,
                      },
                      if (widget.trailingIcon != null) ...[
                        SizedBox(width: Spacing.d8),
                        widget.trailingIcon!,
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
