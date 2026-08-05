import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/motion_system.dart';
import '../../models/experiment_model.dart';

class ExperimentCard extends StatefulWidget {
  final ExperimentModel experiment;
  const ExperimentCard({super.key, required this.experiment});

  @override
  State<ExperimentCard> createState() => _ExperimentCardState();
}

class _ExperimentCardState extends State<ExperimentCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;
  late AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  void _updateMousePosition(PointerEvent event) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final Offset center = box.size.center(Offset.zero);
      final Offset local = event.localPosition;
      setState(() {
        _mousePosition = Offset(
          (local.dx - center.dx) / (box.size.width / 2),
          (local.dy - center.dy) / (box.size.height / 2),
        );
      });
    }
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
      if (!hovering) _mousePosition = Offset.zero;
    });
    if (hovering) {
      _sweepController.forward(from: 0.0);
    } else {
      _sweepController.reverse();
    }
  }

  Color _getStatusColor(ExperimentStatus status) {
    switch (status) {
      case ExperimentStatus.researching:
        return const Color(0xFF94A3B8);
      case ExperimentStatus.exploring:
        return const Color(0xFFA855F7);
      case ExperimentStatus.building:
        return const Color(0xFF4F8CFF);
      case ExperimentStatus.completed:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onHover: _updateMousePosition,
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: MotionSystem.standard,
        curve: MotionSystem.deceleration,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(0.0, _isHovered ? -6.0 : 0.0)
          ..rotateX(_isHovered ? -_mousePosition.dy * 0.04 : 0.0)
          ..rotateY(_isHovered ? _mousePosition.dx * 0.04 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: _isHovered 
              ? [
                  const BoxShadow(color: Color(0x1A4F8CFF), blurRadius: 50, offset: Offset(0, 20)),
                  const BoxShadow(color: Color(0x0C4F8CFF), blurRadius: 15, offset: Offset(0, 8)),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Stack(
              children: [
                AnimatedContainer(
                  clipBehavior: Clip.antiAlias,
                  duration: MotionSystem.standard,
                  curve: MotionSystem.deceleration,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _isHovered ? const Color(0x14FFFFFF) : const Color(0x06FFFFFF),
                        const Color(0x02FFFFFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isHovered ? const Color(0x4DFFFFFF) : const Color(0x12FFFFFF),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: System Status Metadata Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: MotionSystem.swift,
                                curve: MotionSystem.deceleration,
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getStatusColor(widget.experiment.status),
                                  boxShadow: _isHovered
                                      ? [
                                          BoxShadow(
                                            color: _getStatusColor(widget.experiment.status).withOpacity(0.6),
                                            blurRadius: 8,
                                          )
                                        ]
                                      : [],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.experiment.status.label,
                                style: GoogleFonts.geist(
                                  textStyle: TextStyle(
                                    color: _getStatusColor(widget.experiment.status),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.experiment.date,
                            style: GoogleFonts.geist(
                              textStyle: const TextStyle(
                                color: Color(0x59FFFFFF),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      
                      // Experiment Title Label
                      Text(
                        widget.experiment.title,
                        style: GoogleFonts.plusJakartaSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: widget.experiment.isFeatured ? 26 : 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Detailed Context Paragraph
                      Text(
                        widget.experiment.description,
                        style: GoogleFonts.geist(
                          textStyle: const TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.65,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Extended System Metadata Overlay Panel
                      AnimatedSize(
                        duration: MotionSystem.swift,
                        curve: MotionSystem.deceleration,
                        alignment: Alignment.topCenter,
                        child: _isHovered
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'COMPLEXITY: ${widget.experiment.complexity.toUpperCase()}',
                                      style: GoogleFonts.geist(
                                        textStyle: const TextStyle(
                                          color: Color(0xFF4F8CFF),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.experiment.category.toUpperCase(),
                                      style: GoogleFonts.geist(
                                        textStyle: const TextStyle(
                                          color: Color(0x73FFFFFF),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                      
                      // Dynamic Stack Modules Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.experiment.technologies.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0x08FFFFFF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0x0DFFFFFF),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.geist(
                                textStyle: const TextStyle(
                                  color: Color(0x73FFFFFF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                
                // Precision Diagonal Light Reflection Sweep overlay
                AnimatedBuilder(
                  animation: _sweepController,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: CustomPaint(
                        painter: _LabReflectionPainter(progress: _sweepController.value),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabReflectionPainter extends CustomPainter {
  final double progress;
  _LabReflectionPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final double translation = (size.width * 2) * progress - size.width;
    canvas.save();
    canvas.translate(translation, 0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LabReflectionPainter oldDelegate) => oldDelegate.progress != progress;
}