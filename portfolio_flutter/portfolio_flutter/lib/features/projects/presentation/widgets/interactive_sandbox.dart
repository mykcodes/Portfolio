import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/experience_controller.dart';

class InteractiveSandbox extends StatefulWidget {
  final String title;
  const InteractiveSandbox({
    super.key,
    this.title = 'INTERACTIVE SANDBOX (BETA)',
  });

  @override
  State<InteractiveSandbox> createState() => _InteractiveSandboxState();
}

class _InteractiveSandboxState extends State<InteractiveSandbox>
    with TickerProviderStateMixin {
  late AnimationController _ticker;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    for (int i = 0; i < 50; i++) {
      _particles.add(
        _Particle(
          pos: Offset(_random.nextDouble() * 800, _random.nextDouble() * 400),
          vel: Offset(
            (_random.nextDouble() - 0.5) * 2,
            (_random.nextDouble() - 0.5) * 2,
          ),
        ),
      );
    }
    _ticker.addListener(_updatePhysics);

    ExperienceController.instance.addListener(_onSectionChanged);
    _onSectionChanged(); 
  }

  void _onSectionChanged() {
    if (!mounted) return;
    if (ExperienceController.instance.activeSection == 'builds') {
      if (!_ticker.isAnimating) _ticker.repeat();
    } else {
      if (_ticker.isAnimating) _ticker.stop();
    }
  }

  void _updatePhysics() {
    for (var p in _particles) {
      
      final double dx = _mousePos.dx - p.pos.dx;
      final double dy = _mousePos.dy - p.pos.dy;
      final double dist = math.sqrt(dx * dx + dy * dy);

      if (dist < 100 && dist > 0) {
        final double force = (100 - dist) / 100;
        p.vel = Offset(
          p.vel.dx - (dx / dist) * force * 2,
          p.vel.dy - (dy / dist) * force * 2,
        );
      }

      
      p.vel *= 0.98;

      
      final double cdx = 400 - p.pos.dx;
      final double cdy = 200 - p.pos.dy;
      p.vel += Offset(cdx * 0.001, cdy * 0.001);

      p.pos += p.vel;
    }
  }

  @override
  void dispose() {
    ExperienceController.instance.removeListener(_onSectionChanged);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      clipBehavior: Clip.antiAlias,
      child: MouseRegion(
        onHover: (e) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            _mousePos = box.globalToLocal(e.position);
          }
        },
        onExit: (_) {
          _mousePos = const Offset(-1000, -1000);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ticker,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _SandboxPainter(
                      particles: _particles,
                      mousePos: _mousePos,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4F8CFF),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.title,
                    style: GoogleFonts.geist(
                      textStyle: const TextStyle(
                        color: Color(0x99FFFFFF),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  Offset pos;
  Offset vel;
  _Particle({required this.pos, required this.vel});
}

class _SandboxPainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset mousePos;

  _SandboxPainter({required this.particles, required this.mousePos});

  static final Paint _linePaint = Paint()
    ..color = const Color(0x1A4F8CFF)
    ..strokeWidth = 1.0;

  static final Paint _nodePaint = Paint()
    ..color = const Color(0xFF4F8CFF)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i].pos;
        final p2 = particles[j].pos;
        final double distSq = (p1 - p2).distanceSquared;

        if (distSq < 6400) {
          
          final double dist = math.sqrt(distSq);
          _linePaint.color = const Color(
            0xFF4F8CFF,
          ).withValues(alpha: (1 - dist / 80) * 0.3);
          canvas.drawLine(p1, p2, _linePaint);
        }
      }
    }

    
    for (var p in particles) {
      canvas.drawCircle(p.pos, 2.0, _nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SandboxPainter old) => true;
}
