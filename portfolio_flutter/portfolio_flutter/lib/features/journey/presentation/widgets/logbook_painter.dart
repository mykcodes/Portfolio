import 'dart:math' as math;
import 'package:flutter/material.dart';



class LogbookPainter extends CustomPainter {
  final bool isHovered;
  final int seed;

  LogbookPainter({required this.isHovered, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    final random = math.Random(seed);

    final paint = Paint()
      ..color = const Color(
        0xFF4F8CFF,
      ).withValues(alpha: isHovered ? 0.08 : 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    
    final double gridSize = 30.0;
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    
    final nodeCount = random.nextInt(4) + 3;
    final highlightPaint = Paint()
      ..color = const Color(
        0xFF4F8CFF,
      ).withValues(alpha: isHovered ? 0.15 : 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < nodeCount; i++) {
      final center = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final radius = random.nextDouble() * 40 + 20;

      
      canvas.drawCircle(center, radius, highlightPaint);
      if (random.nextBool()) {
        canvas.drawCircle(center, radius * 0.5, paint);
      }

      
      canvas.drawLine(
        Offset(center.dx - radius - 10, center.dy),
        Offset(center.dx + radius + 10, center.dy),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - radius - 10),
        Offset(center.dx, center.dy + radius + 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LogbookPainter oldDelegate) {
    return oldDelegate.isHovered != isHovered || oldDelegate.seed != seed;
  }
}
