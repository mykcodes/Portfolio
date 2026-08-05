import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/dev_mode_controller.dart';

/// Real-time FPS counter with mini bar graph.
/// Renders via CustomPainter for zero widget rebuild cost.
class FpsCounter extends StatelessWidget {
  const FpsCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DevModeController.instance,
      builder: (context, _) {
        final fps = DevModeController.instance.currentFps;
        final history = DevModeController.instance.fpsHistory;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xCC0A0A0A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getFpsColor(fps).withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // FPS number
              Text(
                '${fps.toStringAsFixed(0)} FPS',
                style: GoogleFonts.jetBrainsMono(
                  textStyle: TextStyle(
                    color: _getFpsColor(fps),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Mini bar graph
              SizedBox(
                width: 120,
                height: 30,
                child: CustomPaint(
                  painter: _FpsBarGraphPainter(
                    history: history,
                    currentFps: fps,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getFpsColor(double fps) {
    if (fps >= 55) return const Color(0xFF10B981); // Green
    if (fps >= 30) return const Color(0xFFFEBC2E); // Yellow
    return const Color(0xFFFF5F57); // Red
  }
}

class _FpsBarGraphPainter extends CustomPainter {
  final List<double> history;
  final double currentFps;

  _FpsBarGraphPainter({required this.history, required this.currentFps});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final int count = history.length;
    final double barWidth = (size.width / 60).clamp(1.0, 3.0);
    final double spacing = (size.width - barWidth * count) / (count - 1).clamp(1, 60);

    for (int i = 0; i < count; i++) {
      final double fps = history[i];
      final double normalizedHeight = (fps / 144.0).clamp(0.0, 1.0) * size.height;

      final Color barColor;
      if (fps >= 55) {
        barColor = const Color(0xFF10B981);
      } else if (fps >= 30) {
        barColor = const Color(0xFFFEBC2E);
      } else {
        barColor = const Color(0xFFFF5F57);
      }

      final paint = Paint()
        ..color = barColor.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * (barWidth + spacing),
            size.height - normalizedHeight,
            barWidth,
            normalizedHeight,
          ),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FpsBarGraphPainter oldDelegate) =>
      oldDelegate.history.length != history.length ||
      oldDelegate.currentFps != currentFps;
}
