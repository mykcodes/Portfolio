import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class JourneyPathPainter extends CustomPainter {
  final double scrollProgress;
  final Color pathColor;

  JourneyPathPainter({
    required this.scrollProgress,
    required this.pathColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final Path path = Path();
    final double centerX = size.width / 2;

    path.moveTo(centerX, 0);

    // Creates a premium, subtly curved constellation spine down the center axis
    for (double y = 0; y <= size.height; y += 20) {
      // Procedural sine waves simulate an organic starry pathway connection
      final double wave = sin(y * 0.008) * 24.0 + cos(y * 0.004) * 12.0;
      path.lineTo(centerX + wave, y);
    }

    // Passive underlying trajectory line
    paint.color = pathColor.withOpacity(0.08);
    canvas.drawPath(path, paint);

    // Active illuminated traveling progress path
    final PathMetrics metrics = path.computeMetrics();
    if (metrics.isNotEmpty) {
      final PathMetric metric = metrics.first;
      final double extractLength = metric.length * scrollProgress;
      final Path extractPath = metric.extractPath(0, extractLength);

      glowPaint.color = pathColor.withOpacity(0.18);
      canvas.drawPath(extractPath, glowPaint);

      paint.color = pathColor.withOpacity(0.65);
      canvas.drawPath(extractPath, paint);

      // NEW: Traveling light particle at the leading edge
      if (extractLength > 0) {
        final Tangent? tangent = metric.getTangentForOffset(extractLength);
        if (tangent != null) {
          // Bright leading dot
          final Paint dotPaint = Paint()
            ..color = pathColor.withOpacity(0.9)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(tangent.position, 4.0, dotPaint);

          // Glow halo around the dot
          final Paint haloPaint = Paint()
            ..color = pathColor.withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);
          canvas.drawCircle(tangent.position, 10.0, haloPaint);

          // Wider ambient glow
          final Paint ambientPaint = Paint()
            ..color = pathColor.withOpacity(0.08)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30.0);
          canvas.drawCircle(tangent.position, 30.0, ambientPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant JourneyPathPainter oldDelegate) {
    return oldDelegate.scrollProgress != scrollProgress || oldDelegate.pathColor != pathColor;
  }
}