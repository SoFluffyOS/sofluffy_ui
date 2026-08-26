import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class TableHeaderCell extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool sortAscending;
  final bool isSorted;

  const TableHeaderCell(
    this.text, {
    this.onTap,
    this.sortAscending = true,
    this.isSorted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: Spacing.d24,
          right: Spacing.d8,
          top: Spacing.d8,
          bottom: Spacing.d8,
        ),
        child: Row(
          children: [
            Text(
              text,
              style: context.fluffyTheme.typography.base1,
            ),
            if (isSorted) ...[
              Spacing.h4,
              _SortArrow(
                ascending: sortAscending,
                size: 16,
                color: context.fluffyTheme.typography.base1.color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SortArrow extends StatelessWidget {
  final bool ascending;
  final Color? color;
  final double size;

  const _SortArrow({
    required this.ascending,
    this.color,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SortArrowPainter(
          ascending: ascending,
          color: color ?? FluffyColors.black,
        ),
      ),
    );
  }
}

class _SortArrowPainter extends CustomPainter {
  final bool ascending;
  final Color color;

  _SortArrowPainter({required this.ascending, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (ascending) {
      path.moveTo(size.width * 0.2, size.height * 0.6);
      path.lineTo(size.width * 0.5, size.height * 0.3);
      path.lineTo(size.width * 0.8, size.height * 0.6);
    } else {
      path.moveTo(size.width * 0.2, size.height * 0.4);
      path.lineTo(size.width * 0.5, size.height * 0.7);
      path.lineTo(size.width * 0.8, size.height * 0.4);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SortArrowPainter oldDelegate) =>
      oldDelegate.ascending != ascending || oldDelegate.color != color;
}
