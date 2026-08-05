import 'package:flutter/material.dart';

class LaboratoryBackground extends StatelessWidget {
  const LaboratoryBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _LaboratoryEnvPainter(),
        ),
      ),
    );
  }
}

class _LaboratoryEnvPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = const Color(0x05FFFFFF)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final Paint dotPaint = Paint()
      ..color = const Color(0x1AFFFFFF)
      ..style = PaintingStyle.fill;

    const double gridSize = 60.0;

    // Draw faint blueprint environment
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      for (double x = 0; x < size.width; x += gridSize) {
        if (y == 0) canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
        // Draw engineering connection nodes at intersections
        canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}