import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A [Row] whose [Flexible] children shrink only where the row has a width
/// to keep to. Where its width is unbounded, such as in a horizontal list,
/// they lay out as plain children, where a [Row] would throw.
///
/// Unlike a [LayoutBuilder], it reports its intrinsic size, so it works
/// under [IntrinsicHeight] and [IntrinsicWidth].
class ButtonLabelRow extends Row {
  const ButtonLabelRow({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.children,
  });

  @override
  RenderFlex createRenderObject(BuildContext context) => _RenderButtonLabelRow(
    direction: direction,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: getEffectiveTextDirection(context),
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    clipBehavior: clipBehavior,
    spacing: spacing,
  );
}

class _RenderButtonLabelRow extends RenderFlex {
  _RenderButtonLabelRow({
    super.direction,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    super.spacing,
  });

  @override
  void performLayout() {
    if (constraints.hasBoundedWidth) {
      super.performLayout();
      return;
    }

    final flexes = _clearFlexes();
    try {
      super.performLayout();
    } finally {
      _restoreFlexes(flexes);
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (constraints.hasBoundedWidth) {
      return super.computeDryLayout(constraints);
    }

    final flexes = _clearFlexes();
    try {
      return super.computeDryLayout(constraints);
    } finally {
      _restoreFlexes(flexes);
    }
  }

  List<int?> _clearFlexes() {
    final flexes = <int?>[];
    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData as FlexParentData;
      flexes.add(parentData.flex);
      parentData.flex = null;
      child = parentData.nextSibling;
    }

    return flexes;
  }

  void _restoreFlexes(List<int?> flexes) {
    var child = firstChild;
    var index = 0;
    while (child != null) {
      final parentData = child.parentData as FlexParentData;
      parentData.flex = flexes[index];
      index++;
      child = parentData.nextSibling;
    }
  }
}
