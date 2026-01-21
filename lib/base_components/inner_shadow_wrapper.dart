import 'dart:ui';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InnerShadow extends SingleChildRenderObjectWidget {
  final bool enable;

  const InnerShadow({
    super.key,
    super.child,
    this.enable = true,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _RenderInnerShadow renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderInnerShadow renderObject) {
    renderObject;
    renderObject.enable = enable;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  bool _enable = true;

  bool get enable => _enable;

  set enable(bool value) {
    if (_enable == value) return;
    _enable = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_enable) {
      super.paint(context, offset);
      return;
    }

    final blur = Spacing.d4;
    final color = Colors.black.withValues(alpha: 0.15);

    final child = this.child;
    if (child == null) return;
    const dx = 0.0;
    final dy = Spacing.d4;
    final size = child.size;
    if (size.isEmpty) return;

    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width - dx,
      size.height + dy,
    );
    final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child, offset);
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);

    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(dx, dy);
    context.paintChild(child, offset);
    context.canvas
      ..restore()
      ..restore()
      ..restore();
  }
}
