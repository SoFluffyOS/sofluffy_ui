import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

part 'round_button.dart';

enum ButtonState { normal, hover, focus, pressing, disabled }

enum ButtonTitleExpand { none, shrink, expand }

Brightness _estimateBrightnessForColor(Color color) {
  return color.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark;
}

enum ButtonVariant {
  primary,
  secondary,
  ghost;

  Color? getForegroundColor(
    BuildContext context,
    ButtonState state,
    Color? fillColor,
  ) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    switch (this) {
      case ButtonVariant.primary:
        final baseColor = fillColor ?? theme.colors.primary;
        return switch (_estimateBrightnessForColor(baseColor)) {
          Brightness.light => theme.colors.neutral7,
          Brightness.dark => theme.colors.neutral1,
        };
      case ButtonVariant.secondary:
        if (fillColor != null) {
          return ButtonVariant.primary.getForegroundColor(
            context,
            state,
            fillColor,
          );
        }
        return isDark ? theme.colors.neutral7 : theme.colors.neutral1;
      case ButtonVariant.ghost:
        if (fillColor != null) {
          return fillColor;
        }
        return isDark ? theme.colors.neutral1 : theme.colors.neutral7;
    }
  }

  Color? getBorderColor(
    BuildContext context,
    ButtonState state,
    Color? fillColor,
  ) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    switch (this) {
      /// ButtonVariant.primary.
      case ButtonVariant.primary:
        final baseColor = getBackgroundColor(context, state, fillColor);
        if (state == ButtonState.disabled) {
          return FluffyColors.transparent;
        }
        if (state == ButtonState.pressing) {
          return Color.lerp(baseColor, FluffyColors.black, 0.1);
        }
        return baseColor;

      /// ButtonVariant.ghost.
      case ButtonVariant.ghost:
        if (fillColor != null && state == ButtonState.pressing) {
          return FluffyColors.transparent;
        }
        final baseColor =
            fillColor?.withValues(alpha: 0.25) ??
            (isDark ? theme.colors.neutral5 : theme.colors.neutral3);
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
        return FluffyColors.transparent;
    }
  }

  Color? getBackgroundColor(
    BuildContext context,
    ButtonState state,
    Color? fillColor,
  ) {
    final isDark = context.isDark;
    final theme = context.fluffyTheme;
    switch (this) {
      /// ButtonVariant.primary.
      case ButtonVariant.primary:
        final baseColor = fillColor ?? theme.colors.primary;
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
          final baseColor = isDark
              ? theme.colors.neutral5
              : theme.colors.neutral3;
          if (fillColor != null) {
            return Color.lerp(
              isDark ? theme.colors.neutral7 : theme.colors.neutral1,
              fillColor,
              0.25,
            );
          }
          return baseColor;
        }
        return isDark ? theme.colors.neutral7 : theme.colors.neutral1;

      /// ButtonVariant.secondary.
      case ButtonVariant.secondary:
        final baseColor =
            fillColor ??
            (isDark ? theme.colors.neutral1 : theme.colors.neutral7);
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
      stateNotifier.value = widget.enable
          ? ButtonState.normal
          : ButtonState.disabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = switch (defaultTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };

    late final Widget child;
    if (widget.child case final thisChild?) {
      child = thisChild;
    } else if (widget.label case final label?) {
      final typography = context.fluffyTheme.typography;
      child = Text(
        label,
        style: (isDesktop ? typography.caption1 : typography.base1).copyWith(
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
    } else {
      child = const SizedBox.shrink();
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
            hoverOverlayBorderRadius:
                widget.radius ?? (isDesktop ? Spacing.d8 : Spacing.d12),
            hoverOverlayColorTint:
                widget.color ??
                widget.variant.getBackgroundColor(context, state, widget.color),
            child: Builder(
              builder: (context) {
                final fgColor = widget.variant.getForegroundColor(
                  context,
                  state,
                  widget.color,
                );
                return AnimatedContainer(
                  width: widget.width,
                  height: widget.height,
                  constraints: BoxConstraints(
                    minHeight: isDesktop ? Spacing.d32 : Spacing.d36,
                  ),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  padding:
                      widget.padding ??
                      (isDesktop
                          ? EdgeInsets.symmetric(
                              horizontal: Spacing.d12,
                              vertical: Spacing.d8,
                            )
                          : EdgeInsets.symmetric(
                              horizontal: Spacing.d24,
                              vertical: Spacing.d12,
                            )),
                  decoration: ShapeDecoration(
                    color: widget.variant.getBackgroundColor(
                      context,
                      state,
                      widget.color,
                    ),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          widget.radius ?? (isDesktop ? 8.0 : 12.0),
                        ),
                      ),
                      side: BorderSide(
                        color:
                            widget.variant.getBorderColor(
                              context,
                              state,
                              widget.color,
                            ) ??
                            FluffyColors.transparent,
                        width: widget.borderWidth ?? Spacing.d2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                  ),
                  child: IconTheme.merge(
                    data: IconThemeData(color: fgColor),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(color: fgColor),
                      child: Row(
                        mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
                        mainAxisAlignment:
                            widget.mainAxisAlignment ??
                            MainAxisAlignment.center,
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
                    ),
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
