
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../controllers/experience_controller.dart';

/// A precision-engineered cursor overlay that replaces the default system cursor.
/// Renders a smoothly interpolated ring + dot with velocity-reactive scaling,
/// context-aware expansion on hover targets, and a subtle trailing glow.
///
/// Performance: Uses its own [Ticker] and [CustomPainter] — never triggers
/// widget rebuilds in the main tree. Wrapped in [RepaintBoundary] at mount site.
class PremiumCursorOverlay extends StatefulWidget {
  const PremiumCursorOverlay({super.key});

  @override
  State<PremiumCursorOverlay> createState() => _PremiumCursorOverlayState();
}

class _PremiumCursorOverlayState extends State<PremiumCursorOverlay>
    with TickerProviderStateMixin {
  late Ticker _ticker;

  // Smoothed cursor position (lerped toward actual position)
  Offset _smoothPosition = Offset.zero;
  // Previous frame position for velocity calculation
  Offset _prevPosition = Offset.zero;
  // Current velocity magnitude (normalized 0-1)
  double _velocity = 0.0;
  // Trail positions for ghost effect
  final List<Offset> _trail = [];
  static const int _maxTrailLength = 4;

  // Lerp factor for smooth following (lower = smoother/laggier)
  static const double _smoothFactor = 0.18;
  static const double _velocitySmooth = 0.12;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    final Offset target = ExperienceController.instance.globalCursor;

    // Smooth position interpolation
    _smoothPosition = Offset(
      _smoothPosition.dx + (target.dx - _smoothPosition.dx) * _smoothFactor,
      _smoothPosition.dy + (target.dy - _smoothPosition.dy) * _smoothFactor,
    );

    // Velocity calculation (distance between frames, normalized)
    final double frameDist = (_smoothPosition - _prevPosition).distance;
    final double rawVelocity = (frameDist / 40.0).clamp(0.0, 1.0);
    _velocity = _velocity + (rawVelocity - _velocity) * _velocitySmooth;
    _prevPosition = _smoothPosition;

    // Trail management
    _trail.insert(0, _smoothPosition);
    if (_trail.length > _maxTrailLength) {
      _trail.removeLast();
    }

    // Only repaint the cursor layer
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PremiumCursorPainter(
            position: _smoothPosition,
            velocity: _velocity,
            trail: List.unmodifiable(_trail),
            activeSection: ExperienceController.instance.activeSection,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _PremiumCursorPainter extends CustomPainter {
  final Offset position;
  final double velocity;
  final List<Offset> trail;
  final String activeSection;

  // Design constants
  static const double _ringRadius = 16.0;
  static const double _ringStroke = 1.2;
  static const double _dotRadius = 2.5;
  static const Color _cursorColor = Color(0xDDFFFFFF);

  _PremiumCursorPainter({
    required this.position,
    required this.velocity,
    required this.trail,
    required this.activeSection,
  });
  
  Color get _glowColor {
    switch (activeSection) {
      case 'hero': return const Color(0xFF4F8CFF);
      case 'builds': return const Color(0xFF60A5FA);
      case 'journey': return const Color(0xFFF87171);
      case 'toolbox': return const Color(0xFF34D399);
      case 'lab': return const Color(0xFFA78BFA);
      case 'connection': return const Color(0xFF9CA3AF);
      default: return const Color(0xFF4F8CFF);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (position == Offset.zero) return;

    // Velocity-reactive ring expansion
    final double dynamicRadius = _ringRadius + (velocity * 8.0);
    final double dynamicStroke = _ringStroke + (velocity * 0.4);

    // 1. Outer glow (very subtle, blue-tinted)
    final Paint glowPaint = Paint()
      ..color = _glowColor.withValues(alpha: 0.06 + velocity * 0.04)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20.0);
    canvas.drawCircle(position, dynamicRadius + 12.0, glowPaint);

    // 2. Trail ghost (fading positions from previous frames)
    for (int i = 1; i < trail.length; i++) {
      final double t = i / trail.length;
      final Paint trailPaint = Paint()
        ..color = _cursorColor.withValues(alpha: 0.06 * (1.0 - t) * velocity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = dynamicStroke * (1.0 - t * 0.5);
      canvas.drawCircle(trail[i], dynamicRadius * (1.0 - t * 0.15), trailPaint);
    }

    // 3. Precision ring (outer)
    final Paint ringPaint = Paint()
      ..color = _cursorColor.withValues(alpha: 0.35 + velocity * 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = dynamicStroke;
    canvas.drawCircle(position, dynamicRadius, ringPaint);

    // 4. Inner dot (center)
    final Paint dotPaint = Paint()
      ..color = _cursorColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, _dotRadius, dotPaint);

    // 5. Tiny crosshair lines inside ring (engineering precision detail)
    final Paint crosshairPaint = Paint()
      ..color = _cursorColor.withValues(alpha: 0.12)
      ..strokeWidth = 0.5;

    const double crossLen = 4.0;
    final double innerEdge = dynamicRadius - crossLen - 2.0;
    // Top
    canvas.drawLine(
      Offset(position.dx, position.dy - innerEdge),
      Offset(position.dx, position.dy - innerEdge - crossLen),
      crosshairPaint,
    );
    // Bottom
    canvas.drawLine(
      Offset(position.dx, position.dy + innerEdge),
      Offset(position.dx, position.dy + innerEdge + crossLen),
      crosshairPaint,
    );
    // Left
    canvas.drawLine(
      Offset(position.dx - innerEdge, position.dy),
      Offset(position.dx - innerEdge - crossLen, position.dy),
      crosshairPaint,
    );
    // Right
    canvas.drawLine(
      Offset(position.dx + innerEdge, position.dy),
      Offset(position.dx + innerEdge + crossLen, position.dy),
      crosshairPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PremiumCursorPainter oldDelegate) => true;
}

