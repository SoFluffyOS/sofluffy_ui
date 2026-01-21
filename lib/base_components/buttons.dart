import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'round_button.dart';

enum ButtonState { normal, hover, focus, pressing, disabled }

enum ButtonVariant {
  primary,
  secondary,
  ghost;

  Color? getForegroundColor(
    BuildContext context,
    ButtonState state,
    Color? fillColor,
  ) {
    final isDark = context.theme.brightness == Brightness.dark;
    switch (this) {
      case ButtonVariant.primary:
        return ThemeConfigs().theme.colors.neutral1;
      case ButtonVariant.secondary:
        if (fillColor != null) {
          return ButtonVariant.primary.getForegroundColor(
            context,
            state,
            fillColor,
          );
        }
        return isDark
            ? ThemeConfigs().theme.colors.neutral7
            : ThemeConfigs().theme.colors.neutral1;
      case ButtonVariant.ghost:
        if (fillColor != null) {
          return fillColor;
        }
    }
    return null;
  }

  Color? getBorderColor(
    BuildContext context,
    ButtonState state,
    Color? fillColor,
  ) {
    final isDark = context.theme.brightness == Brightness.dark;
    switch (this) {
      /// ButtonVariant.primary.
      case ButtonVariant.primary:
        final baseColor = getBackgroundColor(context, state, fillColor);
        if (state == ButtonState.disabled) {
          return Colors.transparent;
        }
        if (state == ButtonState.pressing) {
          return Color.lerp(baseColor, Colors.black, 0.1);
        }
        return baseColor;

      /// ButtonVariant.ghost.
      case ButtonVariant.ghost:
        if (fillColor != null && state == ButtonState.pressing) {
          return Colors.transparent;
        }
        final baseColor =
            fillColor?.withValues(alpha: 0.25) ??
            (isDark
                ? ThemeConfigs().theme.colors.neutral5
                : ThemeConfigs().theme.colors.neutral3);
        if (state == ButtonState.disabled) {
          return baseColor.withValues(alpha: 0.5);
        }
        return baseColor;

      /// ButtonVariant.secondary.
      case ButtonVariant.secondary:
        if (fillColor != null) {
          return ButtonVariant.primary.getBorderColor(
            context,
            state,
            fillColor,
          );
        }
        return Colors.transparent;
    }
  }

  Color? getBackgroundColor(
    BuildContext context,
    ButtonState state,
    Color? fillColor,
  ) {
    final isDark = context.theme.brightness == Brightness.dark;
    switch (this) {
      /// ButtonVariant.primary.
      case ButtonVariant.primary:
        final baseColor = fillColor ?? ThemeConfigs().theme.colors.primary;
        if (state == ButtonState.disabled) {
          return baseColor.withValues(alpha: 0.5);
        }
        if (state == ButtonState.hover) {
          return baseColor.withValues(alpha: 0.8);
        }
        return baseColor;

      /// ButtonVariant.ghost.
      case ButtonVariant.ghost:
        if (state == ButtonState.hover || state == ButtonState.pressing) {
          final baseColor =
              isDark
                  ? ThemeConfigs().theme.colors.neutral5
                  : ThemeConfigs().theme.colors.neutral3;
          if (fillColor != null) {
            return Color.lerp(
              context.theme.colorScheme.surface,
              fillColor,
              0.25,
            );
          }
          return baseColor;
        }
        return context.theme.colorScheme.surface;

      /// ButtonVariant.secondary.
      case ButtonVariant.secondary:
        final baseColor =
            fillColor ??
            (isDark
                ? ThemeConfigs().theme.colors.neutral1
                : ThemeConfigs().theme.colors.neutral7);
        if (state == ButtonState.disabled) {
          return baseColor.withValues(alpha: 0.5);
        }
        return baseColor;
    }
  }
}

class Button extends StatefulWidget {
  final ButtonVariant variant;

  final Function? onPressed;

  final String? label;

  final Widget? icon;
  final Widget? child;
  final Widget? trailingIcon;

  final Color? color;

  final bool enable;
  final bool enableHover;

  final bool expandTitle;

  final String? tooltip;
  final String? semanticLabel;

  final double? width;
  final double? height;
  final double? borderWidth;
  final double? radius;

  final EdgeInsets? padding;

  final MainAxisSize? mainAxisSize;
  final MainAxisAlignment? mainAxisAlignment;

  const Button({
    super.key,
    required this.variant,
    this.label,
    this.icon,
    this.trailingIcon,
    this.color,
    this.tooltip,
    this.enable = true,
    this.enableHover = true,
    this.expandTitle = false,
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
  }) : assert(
         (label != null && child == null) || (label == null && child != null),
         'Either label or child must be provided',
       );

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late final ValueNotifier<ButtonState> stateNotifier = ValueNotifier(
    widget.enable ? ButtonState.normal : ButtonState.disabled,
  );

  @override
  void didUpdateWidget(covariant Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enable != oldWidget.enable) {
      stateNotifier.value =
          widget.enable ? ButtonState.normal : ButtonState.disabled;
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
        style: ThemeConfigs().theme.typography.base1.copyWith(
          color: widget.variant.getForegroundColor(
            context,
            stateNotifier.value,
            widget.color,
          ),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
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
            onTap:
                widget.enable
                    ? () {
                      HapticFeedback.lightImpact();
                      widget.onPressed?.call();
                    }
                    : null,
            enableHover: widget.enableHover,
            hoverOverlayBorderRadius: widget.radius ?? Spacing.d12,
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
                        horizontal: Spacing.d24,
                        vertical: Spacing.d12,
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
                          cornerRadius: widget.radius ?? 12.0,
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
                      if (widget.expandTitle) Expanded(child: child),
                      if (!widget.expandTitle) child,
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
