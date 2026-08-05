import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/controllers/experience_controller.dart';

class TechBlueprintBackground extends StatefulWidget {
  const TechBlueprintBackground({super.key});

  @override
  State<TechBlueprintBackground> createState() => _TechBlueprintBackgroundState();
}

class _TechBlueprintBackgroundState extends State<TechBlueprintBackground> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        setState(() {
          _mousePos = e.localPosition;
        });
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          ExperienceController.instance.scrollController,
        ]),
        builder: (context, child) {
          final scrollOffset = ExperienceController.instance.scrollController.hasClients
              ? ExperienceController.instance.scrollController.offset
              : 0.0;
              
          return CustomPaint(
            painter: _BlueprintPainter(
              rotation: _rotationController.value * 2 * pi,
              scrollOffset: scrollOffset,
              mousePos: _mousePos,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BlueprintPainter extends CustomPainter {
  final double rotation;
  final double scrollOffset;
  final Offset mousePos;

  _BlueprintPainter({
    required this.rotation,
    required this.scrollOffset,
    required this.mousePos,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle grid base
    final gridPaint = Paint()
      ..color = const Color(0x054F8CFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double gridSize = 60.0;
    
    // Create subtle parallax on the grid
    final double offsetY = scrollOffset * 0.1 % gridSize;
    
    for (double y = -offsetY; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Interactive PCB traces
    final tracePaint = Paint()
      ..color = const Color(0x1A4F8CFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final traceGlowPaint = Paint()
      ..color = const Color(0x334F8CFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    // Draw some structural lines
    _drawTrace(canvas, tracePaint, traceGlowPaint, [
      Offset(size.width * 0.1, size.height * 0.2 - (scrollOffset * 0.2)),
      Offset(size.width * 0.3, size.height * 0.2 - (scrollOffset * 0.2)),
      Offset(size.width * 0.4, size.height * 0.3 - (scrollOffset * 0.2)),
      Offset(size.width * 0.4, size.height * 0.6 - (scrollOffset * 0.2)),
    ]);

    // Draw rotating blueprint circles
    final center1 = Offset(size.width * 0.8, size.height * 0.3 - (scrollOffset * 0.3));
    final center2 = Offset(size.width * 0.2, size.height * 0.7 - (scrollOffset * 0.15));

    _drawTechnicalCircle(canvas, center1, 150, rotation, true);
    _drawTechnicalCircle(canvas, center2, 220, -rotation * 0.8, false);

    // CAD measurements
    _drawMeasurement(canvas, Offset(size.width * 0.85, size.height * 0.3 - (scrollOffset * 0.3)), 'R: 150.00 mm');
    _drawMeasurement(canvas, Offset(size.width * 0.25, size.height * 0.7 - (scrollOffset * 0.15)), 'R: 220.00 mm');
  }

  void _drawTrace(Canvas canvas, Paint paint, Paint glow, List<Offset> points) {
    if (points.isEmpty) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
      canvas.drawCircle(points[i], 4.0, paint);
    }
    canvas.drawPath(path, glow);
    canvas.drawPath(path, paint);
  }

  void _drawTechnicalCircle(Canvas canvas, Offset center, double radius, double rot, bool isPrimary) {
    final paint = Paint()
      ..color = isPrimary ? const Color(0x1A4F8CFF) : const Color(0x0CFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // React slightly to mouse
    final dx = (mousePos.dx - center.dx) * 0.05;
    final dy = (mousePos.dy - center.dy) * 0.05;
    final adjustedCenter = center + Offset(dx, dy);

    canvas.save();
    canvas.translate(adjustedCenter.dx, adjustedCenter.dy);
    canvas.rotate(rot);

    // Outer dashed ring
    const int dashCount = 36;
    for (int i = 0; i < dashCount; i++) {
      if (i % 3 != 0) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset.zero, radius: radius),
          (i * 2 * pi / dashCount),
          (pi / dashCount),
          false,
          paint,
        );
      }
    }

    // Inner continuous ring
    canvas.drawCircle(Offset.zero, radius * 0.9, paint..strokeWidth = 0.5);

    // Inner crosshair
    canvas.drawLine(Offset(-radius * 0.2, 0), Offset(radius * 0.2, 0), paint);
    canvas.drawLine(Offset(0, -radius * 0.2), Offset(0, radius * 0.2), paint);

    canvas.restore();
  }

  void _drawMeasurement(Canvas canvas, Offset pos, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0x4D4F8CFF),
          fontSize: 10,
          fontFamily: 'Courier', // Fallback for monospace
          letterSpacing: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Subtle line pointing to it
    final paint = Paint()..color = const Color(0x1A4F8CFF)..strokeWidth = 1.0;
    canvas.drawLine(pos, pos + const Offset(20, -20), paint);
    canvas.drawLine(pos + const Offset(20, -20), pos + const Offset(40, -20), paint);

    textPainter.paint(canvas, pos + const Offset(45, -26));
  }

  @override
  bool shouldRepaint(covariant _BlueprintPainter old) {
    return old.rotation != rotation || 
           old.scrollOffset != scrollOffset || 
           old.mousePos != mousePos;
  }
}
