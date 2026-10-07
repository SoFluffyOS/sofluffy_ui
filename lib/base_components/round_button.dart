part of 'buttons.dart';

class RoundButton extends StatefulWidget {
  final GestureTapCallback? onPressed;

  final dynamic icon;

  final bool enable;

  final String? tooltip;
  final String? semanticLabel;

  const RoundButton({
    super.key,
    this.onPressed,
    this.tooltip,
    this.semanticLabel,
    this.enable = true,
    this.icon,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  late final ValueNotifier<ButtonState> stateNotifier = ValueNotifier(
    widget.enable ? ButtonState.normal : ButtonState.disabled,
  );

  @override
  void didUpdateWidget(covariant RoundButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enable != oldWidget.enable) {
      stateNotifier.value = widget.enable
          ? ButtonState.normal
          : ButtonState.disabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? widget.tooltip,
      button: true,
      enabled: widget.enable,
      child: ValueListenableBuilder<ButtonState>(
        valueListenable: stateNotifier,
        builder: (context, state, _) {
          final isDark = context.isDark;
          final theme = context.fluffyTheme;
          final borderColor = isDark
              ? switch (state) {
                  ButtonState.pressing ||
                  ButtonState.focus ||
                  ButtonState.hover => theme.colors.neutral1,
                  ButtonState.disabled => theme.colors.neutral4.withValues(
                    alpha: 0.2,
                  ),
                  _ => theme.colors.neutral4.withValues(
                    alpha: 0.25,
                  ),
                }
              : switch (state) {
                  ButtonState.pressing ||
                  ButtonState.focus ||
                  ButtonState.hover => theme.colors.neutral7,
                  ButtonState.disabled => theme.colors.neutral2.withValues(
                    alpha: 0.2,
                  ),
                  _ => theme.colors.neutral2,
                };
          final backgroundColor = isDark
              ? switch (state) {
                  ButtonState.pressing ||
                  ButtonState.focus ||
                  ButtonState.hover => theme.colors.neutral1,
                  ButtonState.disabled => theme.colors.neutral7.withValues(
                    alpha: 0.2,
                  ),
                  _ => theme.colors.neutral7,
                }
              : switch (state) {
                  ButtonState.pressing ||
                  ButtonState.focus ||
                  ButtonState.hover => theme.colors.neutral7,
                  _ => theme.colors.neutral2,
                };
          final iconColor = isDark
              ? switch (state) {
                  ButtonState.pressing ||
                  ButtonState.focus ||
                  ButtonState.hover => theme.colors.neutral7,
                  ButtonState.disabled => theme.colors.neutral4.withValues(
                    alpha: 0.2,
                  ),
                  _ => theme.colors.neutral1,
                }
              : switch (state) {
                  ButtonState.pressing ||
                  ButtonState.focus ||
                  ButtonState.hover => theme.colors.neutral1,
                  ButtonState.disabled => theme.colors.neutral4.withValues(
                    alpha: 0.2,
                  ),
                  _ => theme.colors.neutral7,
                };
          return Tappable(
            onTap: widget.enable ? widget.onPressed : null,
            enableHover: widget.enable,
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
            child: Container(
              width: Spacing.d40,
              height: Spacing.d40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor, width: Spacing.d2),
                borderRadius: BorderRadius.circular(Spacing.d20),
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: iconColor,
                  size: Spacing.d20,
                ),
                child: Center(
                  child: switch (widget.icon) {
                    final IconData iconData => Icon(
                      iconData,
                      size: Spacing.d20,
                      color: iconColor,
                    ),
                    final String assetPath => ImageView(
                      assetPath,
                      size: Spacing.d20,
                      color: iconColor,
                    ),
                    final Widget iconWidget => SizedBox.square(
                      dimension: Spacing.d20,
                      child: Center(child: iconWidget),
                    ),
                    _ => SizedBox.square(dimension: Spacing.d20),
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
