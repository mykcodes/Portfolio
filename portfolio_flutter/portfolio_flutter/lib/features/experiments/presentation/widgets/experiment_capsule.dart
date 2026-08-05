import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/experiment_model.dart';

class ExperimentCapsule extends StatefulWidget {
  final ExperimentModel experiment;
  final int index;

  const ExperimentCapsule({
    super.key,
    required this.experiment,
    required this.index,
  });

  @override
  State<ExperimentCapsule> createState() => _ExperimentCapsuleState();
}

class _ExperimentCapsuleState extends State<ExperimentCapsule> with TickerProviderStateMixin {
  // Assembly Animation (Plays once on mount)
  late AnimationController _assemblyController;
  late Animation<double> _glassAnim;
  late Animation<double> _borderAnim;
  late Animation<double> _titleAnim;
  late Animation<double> _statusAnim;
  late Animation<double> _progressAnim;
  late Animation<double> _notesAnim;

  // Interaction Animations
  late AnimationController _hoverController;
  late AnimationController _particleController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _setupAssemblyAnimations();
    _setupHoverAnimations();

    // Staggered cinematic assembly trigger
    Future.delayed(Duration(milliseconds: 300 + (widget.index * 250)), () {
      if (mounted) _assemblyController.forward();
    });
  }

  void _setupAssemblyAnimations() {
    _assemblyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _glassAnim = CurvedAnimation(parent: _assemblyController, curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic));
    _borderAnim = CurvedAnimation(parent: _assemblyController, curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic));
    _titleAnim = CurvedAnimation(parent: _assemblyController, curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic));
    _statusAnim = CurvedAnimation(parent: _assemblyController, curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic));
    _progressAnim = CurvedAnimation(parent: _assemblyController, curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic));
    _notesAnim = CurvedAnimation(parent: _assemblyController, curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic));
  }

  // Ambient pulse for status indicator — always breathing
  late AnimationController _pulseController;

  void _setupHoverAnimations() {
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _assemblyController.dispose();
    _hoverController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _hoverController.forward();
      _particleController.repeat();
    } else {
      _hoverController.reverse();
      _particleController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _assemblyController,
      builder: (context, child) {
        if (_glassAnim.value == 0) return const SizedBox.shrink();

        return MouseRegion(
          onEnter: (_) => _handleHover(true),
          onExit: (_) => _handleHover(false),
          cursor: SystemMouseCursors.basic, // Capsules are for viewing, not clicking
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
            child: Opacity(
              opacity: _glassAnim.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered ? const Color(0x1A4F8CFF) : Colors.transparent,
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                    child: Stack(
                      children: [
                        // Core Capsule Background
                        Container(
                          clipBehavior: Clip.antiAlias,
                          width: double.infinity,
                          padding: const EdgeInsets.all(32.0),
                          decoration: BoxDecoration(
                            color: const Color(0x0AFFFFFF),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Color.lerp(
                                const Color(0x1AFFFFFF), 
                                const Color(0x4D4F8CFF), 
                                _hoverController.value
                              )!.withOpacity(_borderAnim.value * (_isHovered ? 0.6 : 0.2)),
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Top Meta Row
                              Opacity(
                                opacity: _statusAnim.value,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildStatusIndicator(),
                                    Text(
                                      widget.experiment.lastUpdated,
                                      style: GoogleFonts.geist(
                                        textStyle: const TextStyle(
                                          color: Color(0x59FFFFFF),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Capsule Title
                              Opacity(
                                opacity: _titleAnim.value,
                                child: Text(
                                  widget.experiment.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Segmented Calibration Progress
                              Opacity(
                                opacity: _progressAnim.value,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RESEARCH PROGRESS',
                                      style: GoogleFonts.geist(
                                        textStyle: const TextStyle(
                                          color: Color(0x73FFFFFF),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildSegmentedProgress(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              
                              // Engineering Notes (Monospace)
                              Opacity(
                                opacity: _notesAnim.value,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0x05FFFFFF),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0x0AFFFFFF)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '> LOG_ENTRY // ${widget.experiment.currentObjective}',
                                        style: GoogleFonts.jetBrainsMono(
                                          textStyle: const TextStyle(
                                            color: Color(0xFF4F8CFF),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.experiment.engineeringNotes,
                                        style: GoogleFonts.jetBrainsMono(
                                          textStyle: const TextStyle(
                                            color: Color(0x8CFFFFFF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Hidden Details (Revealed on Hover)
                              SizeTransition(
                                sizeFactor: _hoverController,
                                axisAlignment: -1.0,
                                child: FadeTransition(
                                  opacity: _hoverController,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildMetaTag('DIFFICULTY', widget.experiment.difficulty),
                                        _buildMetaTag('ETA', widget.experiment.estimatedCompletion),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Internal Hover Blueprint Overlay & Escaping Particles
                        Positioned.fill(
                          child: IgnorePointer(
                            child: FadeTransition(
                              opacity: _hoverController,
                              child: AnimatedBuilder(
                                animation: _particleController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: _CapsuleBlueprintPainter(
                                      particleTime: _particleController.value,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_hoverController, _pulseController]),
          builder: (context, child) {
            // Ambient breathing at rest + stronger glow on hover
            final double ambientPulse = _pulseController.value * 0.3;
            final double hoverBoost = _hoverController.value * 0.6;
            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4F8CFF),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F8CFF).withOpacity((0.3 + ambientPulse + hoverBoost).clamp(0.0, 1.0)),
                    blurRadius: 6 + (ambientPulse * 6) + (_hoverController.value * 8),
                  )
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          widget.experiment.status.label,
          style: GoogleFonts.geist(
            textStyle: const TextStyle(
              color: Color(0xFF4F8CFF),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedProgress() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        return Row(
          children: List.generate(10, (index) {
            final bool isActive = index < widget.experiment.progress;
            // Active segments shimmer with staggered phase
            final double shimmer = isActive
                ? 0.7 + (_pulseController.value * 0.3 * ((index % 3 == 0) ? 1.0 : 0.6))
                : 0.0;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index == 9 ? 0 : 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Color.lerp(const Color(0x80FFFFFF), const Color(0xCCFFFFFF), shimmer)
                      : const Color(0x1AFFFFFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMetaTag(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.geist(
            textStyle: const TextStyle(
              color: Color(0x59FFFFFF),
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toUpperCase(),
          style: GoogleFonts.geist(
            textStyle: const TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Draws a subtle internal grid blueprint and tiny escaping particles
class _CapsuleBlueprintPainter extends CustomPainter {
  final double particleTime;
  final Random _random = Random(42); // Fixed seed for consistent particle layout per capsule

  _CapsuleBlueprintPainter({required this.particleTime});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0A4F8CFF)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Subtle internal blueprint grid
    const double gridSize = 32.0;
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Escaping particles (drifting upwards)
    final particlePaint = Paint()..color = const Color(0x804F8CFF);
    for (int i = 0; i < 15; i++) {
      final double startX = _random.nextDouble() * size.width;
      final double speed = 0.2 + _random.nextDouble() * 0.8;
      
      // Calculate continuous upward motion wrapped around the capsule height
      double y = size.height - ((particleTime * size.height * speed + (_random.nextDouble() * size.height)) % size.height);
      
      canvas.drawCircle(Offset(startX, y), 1.0, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CapsuleBlueprintPainter oldDelegate) => true; // Needs constant repaint during hover
}