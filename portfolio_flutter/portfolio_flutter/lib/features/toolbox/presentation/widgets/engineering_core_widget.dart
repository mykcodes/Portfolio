import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EngineeringCoreWidget extends StatefulWidget {
  const EngineeringCoreWidget({super.key});

  @override
  State<EngineeringCoreWidget> createState() => _EngineeringCoreWidgetState();
}

class _EngineeringCoreWidgetState extends State<EngineeringCoreWidget> with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _orbitController;
  
  bool _isCoreHovered = false;
  
  final List<_TechModule> _modules = [
    _TechModule(name: 'Flutter', orbitLevel: 1, angleOffset: 0.0, speedMultiplier: 1.0),
    _TechModule(name: 'C++', orbitLevel: 1, angleOffset: 3.14, speedMultiplier: 1.0),
    _TechModule(name: 'Cloud', orbitLevel: 2, angleOffset: 1.0, speedMultiplier: 0.8),
    _TechModule(name: 'AI', orbitLevel: 2, angleOffset: 4.14, speedMultiplier: 0.8),
    _TechModule(name: 'Python', orbitLevel: 2, angleOffset: 2.5, speedMultiplier: 0.8),
    _TechModule(name: 'Cybersecurity', orbitLevel: 3, angleOffset: 0.5, speedMultiplier: 0.6),
    _TechModule(name: 'Docker', orbitLevel: 3, angleOffset: 2.0, speedMultiplier: 0.6),
    _TechModule(name: 'Firebase', orbitLevel: 3, angleOffset: 3.5, speedMultiplier: 0.6),
    _TechModule(name: 'Node', orbitLevel: 3, angleOffset: 5.0, speedMultiplier: 0.6),
    _TechModule(name: 'Linux', orbitLevel: 4, angleOffset: 1.5, speedMultiplier: 0.4),
    _TechModule(name: 'Git', orbitLevel: 4, angleOffset: 4.5, speedMultiplier: 0.4),
  ];

  _TechModule? _activeModule;

  @override
  void initState() {
    super.initState();
    // Orb breathing and plasma shifting
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Continuous orbital rotation
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _orbController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  void _onModuleTapped(_TechModule module) {
    setState(() {
      if (_activeModule == module) {
        _activeModule = null; // Toggle off
      } else {
        _activeModule = module;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth >= 1024;
        
        final center = Offset(
          isDesktop ? screenWidth * 0.4 : screenWidth * 0.5, 
          isDesktop ? 350 : 300,
        );
        
        return SizedBox(
          width: double.infinity,
          height: isDesktop ? 700 : 600,
          child: Stack(
            children: [
              // Background Layer
              RepaintBoundary(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _CoreBackgroundPainter(),
                ),
              ),

              // Energy Connections
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _orbitController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: _EnergyConnectionsPainter(
                        modules: _modules,
                        center: center,
                        rotationValue: _orbitController.value,
                        activeModule: _activeModule,
                      ),
                    );
                  },
                ),
              ),

              // Orbiting Modules
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _orbitController,
                  builder: (context, child) {
                    return Stack(
                      children: _modules.map((m) {
                        return _ModuleWidget(
                          module: m,
                          center: center,
                          rotationValue: _orbitController.value,
                          isActive: _activeModule == m,
                          onTap: () => _onModuleTapped(m),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              // The Central Living Orb
              Positioned(
                left: center.dx - 60,
                top: center.dy - 60,
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isCoreHovered = true),
                  onExit: (_) => setState(() => _isCoreHovered = false),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _activeModule = null);
                      // Haptic/Shockwave logic could go here
                    },
                    child: _CoreOrb(
                      orbController: _orbController,
                      isHovered: _isCoreHovered,
                    ),
                  ),
                ),
              ),

              // Floating Information Panel (Active Module Details)
              if (_activeModule != null)
                Positioned(
                  right: isDesktop ? 40 : 20,
                  top: isDesktop ? 100 : 20,
                  width: isDesktop ? 380 : screenWidth - 40,
                  child: _FloatingInfoPanel(module: _activeModule!, onClose: () => setState(() => _activeModule = null)),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CoreOrb extends StatelessWidget {
  final AnimationController orbController;
  final bool isHovered;

  const _CoreOrb({required this.orbController, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: orbController,
      builder: (context, child) {
        final breath = orbController.value;
        final scale = 1.0 + (breath * 0.05) + (isHovered ? 0.1 : 0.0);
        final glowOpacity = 0.5 + (breath * 0.3) + (isHovered ? 0.2 : 0.0);
        
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                // Outer Volumetric Glow
                BoxShadow(
                  color: const Color(0xFF4F8CFF).withValues(alpha: glowOpacity * 0.3),
                  blurRadius: 100,
                  spreadRadius: 20 + (breath * 10),
                ),
                // Inner Core Heat
                BoxShadow(
                  color: const Color(0xFF4F8CFF).withValues(alpha: glowOpacity * 0.6),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.9),
                  const Color(0xFFC0EBFF).withValues(alpha: 0.8),
                  const Color(0xFF4F8CFF).withValues(alpha: 0.6),
                  const Color(0xFF0F1A3A).withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
                // Plasma shifting effect
                center: Alignment(0.1 * math.cos(breath * math.pi), 0.1 * math.sin(breath * math.pi)),
              ),
            ),
            child: CustomPaint(
              painter: _OrbRingsPainter(rotation: breath * math.pi * 2, isHovered: isHovered),
            ),
          ),
        );
      },
    );
  }
}

class _OrbRingsPainter extends CustomPainter {
  final double rotation;
  final bool isHovered;

  _OrbRingsPainter({required this.rotation, required this.isHovered});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: isHovered ? 0.4 : 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size.width * 0.9, height: size.height * 0.3), paint);
    canvas.rotate(math.pi / 3);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size.width * 0.85, height: size.height * 0.25), paint);
    canvas.rotate(math.pi / 3);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size.width * 0.9, height: size.height * 0.3), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OrbRingsPainter oldDelegate) => true;
}

class _TechModule {
  final String name;
  final int orbitLevel;
  final double angleOffset;
  final double speedMultiplier;

  _TechModule({
    required this.name,
    required this.orbitLevel,
    required this.angleOffset,
    required this.speedMultiplier,
  });
}

class _EnergyConnectionsPainter extends CustomPainter {
  final List<_TechModule> modules;
  final Offset center;
  final double rotationValue;
  final _TechModule? activeModule;

  _EnergyConnectionsPainter({
    required this.modules,
    required this.center,
    required this.rotationValue,
    required this.activeModule,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final defaultPaint = Paint()
      ..color = const Color(0xFF4F8CFF).withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final activePaint = Paint()
      ..color = const Color(0xFF4F8CFF).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var m in modules) {
      final double radius = 100.0 + (m.orbitLevel * 60.0);
      final double currentAngle = m.angleOffset + (rotationValue * math.pi * 2 * m.speedMultiplier);
      
      final dx = center.dx + math.cos(currentAngle) * radius;
      final dy = center.dy + math.sin(currentAngle) * radius;
      
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..quadraticBezierTo(
          center.dx + (dx - center.dx) * 0.5,
          center.dy + (dy - center.dy) * 0.2, // Adds a slight curve to the energy line
          dx, dy
        );

      canvas.drawPath(path, m == activeModule ? activePaint : defaultPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyConnectionsPainter oldDelegate) => true;
}

class _ModuleWidget extends StatefulWidget {
  final _TechModule module;
  final Offset center;
  final double rotationValue;
  final bool isActive;
  final VoidCallback onTap;

  const _ModuleWidget({
    required this.module,
    required this.center,
    required this.rotationValue,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_ModuleWidget> createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<_ModuleWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final double radius = 100.0 + (widget.module.orbitLevel * 60.0) + (_isHovered ? 10.0 : 0.0);
    final double currentAngle = widget.module.angleOffset + (widget.rotationValue * math.pi * 2 * widget.module.speedMultiplier);
    
    final dx = widget.center.dx + math.cos(currentAngle) * radius;
    final dy = widget.center.dy + math.sin(currentAngle) * radius;

    return Positioned(
      left: dx - 40,
      top: dy - 20,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: widget.isActive || _isHovered ? const Color(0x1A4F8CFF) : const Color(0x05FFFFFF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isActive || _isHovered ? const Color(0x664F8CFF) : const Color(0x1AFFFFFF),
                width: 1,
              ),
              boxShadow: widget.isActive || _isHovered
                  ? [BoxShadow(color: const Color(0x334F8CFF), blurRadius: 10, spreadRadius: 1)]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.module.name,
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  color: widget.isActive || _isHovered ? Colors.white : const Color(0x8CFFFFFF),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingInfoPanel extends StatelessWidget {
  final _TechModule module;
  final VoidCallback onClose;

  const _FloatingInfoPanel({required this.module, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0x0AFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x1AFFFFFF), width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      module.name,
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                      onPressed: onClose,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoRow(title: 'Classification', value: 'Primary Capability'),
                _InfoRow(title: 'Experience', value: 'Production Level'),
                _InfoRow(title: 'Integrations', value: 'Multiple active systems'),
                const SizedBox(height: 24),
                Text(
                  'Engineering Philosophy',
                  style: GoogleFonts.geist(
                    textStyle: const TextStyle(
                      color: Color(0xFF4F8CFF),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Utilized extensively to architect scalable, high-performance systems with strict adherence to maintainability and clean design patterns.',
                  style: GoogleFonts.geist(
                    textStyle: const TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
              textStyle: const TextStyle(color: Color(0x66FFFFFF), fontSize: 11),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.geist(
              textStyle: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoreBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x05FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Faint blueprint grid
    const double gridSize = 40.0;
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Tiny floating particles (static for performance, relies on parallax)
    final dotPaint = Paint()..color = const Color(0x1AFFFFFF);
    final random = math.Random(42); // Seeded for consistency
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CoreBackgroundPainter oldDelegate) => false;
}
