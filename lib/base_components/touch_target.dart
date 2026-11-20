import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/themes/fluffy_density.dart';

/// Grows the area a tap lands on to the [FluffyDensity.minTarget] of the
/// nearest [FluffyDensityScope], centring [child] in it at its own size.
///
/// A tap in the margin goes to [child], moved onto its middle on each axis
/// the tap is beside it, so a control with its own gestures, such as a
/// text field or a switch, takes it too. With
/// [FluffyDensity.pointer], [child] lays out alone, as without it. Parents
/// that size their children tightly, such as a row with a fixed extent,
/// keep that size: give those [FluffyDensity.extent].
class TouchTarget extends StatelessWidget {
  const TouchTarget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final minTarget = context.fluffyDensity.minTarget;
    if (minTarget <= 0) {
      return child;
    }

    return MinTouchSize(minSize: minTarget, child: child);
  }
}

/// Lays [child] out as its parent asks, then takes at least [minSize] on
/// each side its parent allows, with [child] centred. Hits in the margin
/// go to [child], moved onto its middle on each axis they're beside it.
class MinTouchSize extends SingleChildRenderObjectWidget {
  const MinTouchSize({super.key, required this.minSize, super.child});

  final double minSize;

  @override
  RenderMinTouchSize createRenderObject(BuildContext context) =>
      RenderMinTouchSize(minSize: minSize);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderMinTouchSize renderObject,
  ) {
    renderObject.minSize = minSize;
  }
}

class RenderMinTouchSize extends RenderShiftedBox {
  RenderMinTouchSize({required double minSize, RenderBox? child})
    : _minSize = minSize,
      super(child);

  double _minSize;
  double get minSize => _minSize;
  set minSize(double value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  Size _grow(BoxConstraints constraints, Size childSize) =>
      constraints.constrain(
        Size(
          math.max(childSize.width, _minSize),
          math.max(childSize.height, _minSize),
        ),
      );

  @override
  double computeMinIntrinsicWidth(double height) =>
      math.max(super.computeMinIntrinsicWidth(height), _minSize);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      math.max(super.computeMaxIntrinsicWidth(height), _minSize);

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(super.computeMinIntrinsicHeight(width), _minSize);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(super.computeMaxIntrinsicHeight(width), _minSize);

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final child = this.child;
    if (child == null) {
      return constraints.constrain(Size.square(_minSize));
    }

    return _grow(constraints, child.getDryLayout(constraints));
  }

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final child = this.child;
    if (child == null) {
      return null;
    }

    final childSize = child.getDryLayout(constraints);
    final childBaseline = child.getDryBaseline(constraints, baseline);
    if (childBaseline == null) {
      return null;
    }

    final size = _grow(constraints, childSize);
    return childBaseline + (size.height - childSize.height) / 2;
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.constrain(Size.square(_minSize));
      return;
    }

    child.layout(constraints, parentUsesSize: true);
    size = _grow(constraints, child.size);
    final parentData = child.parentData as BoxParentData;
    parentData.offset = Offset(
      (size.width - child.size.width) / 2,
      (size.height - child.size.height) / 2,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) {
      return false;
    }

    final child = this.child;
    if (child == null || child.size.isEmpty) {
      return false;
    }

    final parentData = child.parentData as BoxParentData;
    final childRect = parentData.offset & child.size;
    final isWithinWidth =
        position.dx >= childRect.left && position.dx < childRect.right;
    final isWithinHeight =
        position.dy >= childRect.top && position.dy < childRect.bottom;
    final inChild = Offset(
      switch (isWithinWidth) {
        true => position.dx,
        false => childRect.center.dx,
      },
      switch (isWithinHeight) {
        true => position.dy,
        false => childRect.center.dy,
      },
    );
    final isHit = _hitChild(result, child, parentData.offset, inChild);
    if (isHit) {
      result.add(BoxHitTestEntry(this, position));
    }
    return isHit;
  }

  bool _hitChild(
    BoxHitTestResult result,
    RenderBox child,
    Offset offset,
    Offset position,
  ) => result.addWithPaintOffset(
    offset: offset,
    position: position,
    hitTest: (result, transformed) =>
        child.hitTest(result, position: transformed),
  );
}
