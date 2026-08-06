import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/experience_controller.dart';

class BootSequenceOverlay extends StatefulWidget {
  const BootSequenceOverlay({super.key});

  @override
  State<BootSequenceOverlay> createState() => _BootSequenceOverlayState();
}

class _BootSequenceOverlayState extends State<BootSequenceOverlay> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  
  String _terminalOutput = "";
  double _bootProgress = 0.0;
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
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      value: 1.0,
    );

    _runCinematicBoot();
  }

  Future<void> _runCinematicBoot() async {
    // Staggered Terminal Typing
    await Future.delayed(const Duration(milliseconds: 600));
    for (int i = 0; i < _bootLogs.length; i++) {
      if (!mounted) return;
      setState(() {
        _terminalOutput = _bootLogs[i];
        _bootProgress = (i + 1) / _bootLogs.length;
      });
      await Future.delayed(const Duration(milliseconds: 350));
    }

    await Future.delayed(const Duration(milliseconds: 300));
    
    // Command the Global Controller to wake the portfolio world
    ExperienceController.instance.beginWakeUpSequence();

    // Dissolve the overlay smoothly
    if (mounted) {
      await _fadeController.reverse();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        if (_fadeController.value == 0) return const SizedBox.shrink();
        
        return IgnorePointer(
          ignoring: _fadeController.value < 1.0,
          child: Opacity(
            opacity: _fadeController.value,
            child: Container(
              color: const Color(0xFF050505),
              child: Stack(
                children: [
                  // Background Blueprint Grid (faint engineering feel)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _BootGridPainter(),
                    ),
                  ),

                  // Core Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
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
                        const SizedBox(height: 12),
                        Text(
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
                        const SizedBox(height: 64),
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
                        const SizedBox(height: 24),

                        // Progress bar
                        SizedBox(
                          width: 200,
                          child: Stack(
                            children: [
                              // Track
                              Container(
                                height: 1,
                                width: 200,
                                color: const Color(0x1AFFFFFF),
                              ),
                              // Fill
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                height: 1,
                                width: 200 * _bootProgress,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4F8CFF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4F8CFF).withValues(alpha: 0.5),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              // Leading dot
                              if (_bootProgress > 0)
                                Positioned(
                                  left: (200 * _bootProgress) - 2,
                                  top: -1.5,
                                  child: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF4F8CFF).withValues(alpha: 0.8),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Faint blueprint grid for boot screen background
class _BootGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x08FFFFFF)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const double gridSize = 60.0;

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Subtle center crosshair
    final Paint centerPaint = Paint()
      ..color = const Color(0x0AFFFFFF)
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(size.width / 2 - 40, size.height / 2),
      Offset(size.width / 2 + 40, size.height / 2),
      centerPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - 40),
      Offset(size.width / 2, size.height / 2 + 40),
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

