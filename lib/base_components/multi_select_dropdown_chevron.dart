part of 'multi_select_dropdown.dart';

class _DropdownChevron extends StatelessWidget {
  const _DropdownChevron({required this.color, required this.expanded});

  final Color color;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: switch (expanded) {
        true => 0.5,
        false => 0,
      },
      duration: FluffyDurations.fast,
      child: CustomPaint(
        size: Size.square(Spacing.d14),
        painter: _DropdownChevronPainter(color),
      ),
    );
  }
}

class _DropdownChevronPainter extends CustomPainter {
  const _DropdownChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = Spacing.d2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.65)
      ..lineTo(size.width * 0.75, size.height * 0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DropdownChevronPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
