import 'package:flutter/material.dart';







class CursorLightPainter extends CustomPainter {
  
  final Offset normalizedPosition;

  
  final bool isActive;

  
  final Color lightColor;

  
  final double radius;

  
  final double intensity;

  CursorLightPainter({
    required this.normalizedPosition,
    required this.isActive,
    this.lightColor = const Color(0xFF4F8CFF),
    this.radius = 200.0,
    this.intensity = 0.12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;

    
    final double cx = (normalizedPosition.dx * 0.5 + 0.5) * size.width;
    final double cy = (normalizedPosition.dy * 0.5 + 0.5) * size.height;
    final Offset center = Offset(cx, cy);

    
    final Paint spotlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          lightColor.withValues(alpha: intensity),
          lightColor.withValues(alpha: intensity * 0.3),
          lightColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      spotlightPaint,
    );

    
    final Paint ambientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          lightColor.withValues(alpha: intensity * 0.15),
          lightColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 2.5));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), ambientPaint);
  }

  @override
  bool shouldRepaint(covariant CursorLightPainter oldDelegate) {
    return oldDelegate.normalizedPosition != normalizedPosition ||
        oldDelegate.isActive != isActive;
  }
}



class CursorLightOverlay extends StatelessWidget {
  final Offset normalizedMousePosition;
  final bool isHovered;
  final Color lightColor;
  final double radius;
  final double intensity;

  const CursorLightOverlay({
    super.key,
    required this.normalizedMousePosition,
    required this.isHovered,
    this.lightColor = const Color(0xFF4F8CFF),
    this.radius = 200.0,
    this.intensity = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: CursorLightPainter(
            normalizedPosition: normalizedMousePosition,
            isActive: isHovered,
            lightColor: lightColor,
            radius: radius,
            intensity: intensity,
          ),
        ),
      ),
    );
  }
}
