import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/motion_system.dart';

class BootSequenceView extends StatefulWidget {
  const BootSequenceView({super.key});

  @override
  State<BootSequenceView> createState() => _BootSequenceViewState();
}

class _BootSequenceViewState extends State<BootSequenceView> with TickerProviderStateMixin {
  late AnimationController _masterController;
  late Animation<double> _constellationFade;
  late Animation<double> _logoFade;
  late Animation<double> _subtitleFade;
  
  String _terminalOutput = "";
  final List<String> _bootLogs = [
    "Loading Motion Engine...",
    "Loading Research Lab...",
    "Loading Experience Engine...",
    "Optimizing Interface...",
    "Ready."
  ];

  @override
  void initState() {
    super.initState();
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _constellationFade = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.0, 0.3, curve: MotionSystem.cinematic),
    );
    
    _logoFade = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.2, 0.5, curve: MotionSystem.deceleration),
    );
    
    _subtitleFade = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.4, 0.7, curve: MotionSystem.deceleration),
    );

    _runCinematicBoot();
  }

  Future<void> _runCinematicBoot() async {
    _masterController.forward();
    
    // Staggered Terminal Typing
    await Future.delayed(const Duration(milliseconds: 800));
    for (String log in _bootLogs) {
      if (!mounted) return;
      setState(() => _terminalOutput = log);
      await Future.delayed(const Duration(milliseconds: 400));
    }

    // Final hold before dissolve
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (mounted) {
      // Navigate to Home with a custom fade transition handled by GoRouter
      context.go(AppRoutes.homePath);
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          // Ambient Initial Constellation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _constellationFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _constellationFade.value * 0.3,
                  child: CustomPaint(
                    painter: _BootConstellationPainter(),
                  ),
                );
              },
            ),
          ),
          
          // Core Branding & Terminal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoFade,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoFade.value,
                      child: Transform.translate(
                        offset: Offset(0, 10 * (1 - _logoFade.value)),
                        child: Text(
                          'MYK-CODES',
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 4.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: _subtitleFade,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _subtitleFade.value,
                      child: Transform.translate(
                        offset: Offset(0, 10 * (1 - _subtitleFade.value)),
                        child: Text(
                          'Engineering Experiences.',
                          style: GoogleFonts.geist(
                            textStyle: const TextStyle(
                              color: Color(0xFF4F8CFF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 6.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 64),
                
                // Active Initialization Terminal
                SizedBox(
                  height: 20,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      _terminalOutput.isEmpty ? "" : "> $_terminalOutput",
                      key: ValueKey<String>(_terminalOutput),
                      style: GoogleFonts.jetBrainsMono(
                        textStyle: const TextStyle(
                          color: Color(0x73FFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BootConstellationPainter extends CustomPainter {
  final Random _random = Random(42); // Fixed seed for consistent boot visual

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final List<Offset> points = [];
    for (int i = 0; i < 40; i++) {
      points.add(Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      ));
    }

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 1.5, paint);
      for (int j = i + 1; j < points.length; j++) {
        if ((points[i] - points[j]).distance < 120) {
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
