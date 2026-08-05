import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/motion_system.dart';
import '../../../../core/widgets/cursor_light_painter.dart';
import '../../models/milestone_model.dart';
import 'logbook_painter.dart';

class MilestoneCard extends StatefulWidget {
  final MilestoneModel milestone;
  final bool isLeft;

  const MilestoneCard({
    super.key,
    required this.milestone,
    required this.isLeft,
  });

  @override
  State<MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<MilestoneCard> {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  void _onHover(PointerEvent event) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final Offset center = box.size.center(Offset.zero);
      final Offset local = event.localPosition;
      setState(() {
        _isHovered = true;
        _mousePosition = Offset(
          (local.dx - center.dx) / (box.size.width / 2),
          (local.dy - center.dy) / (box.size.height / 2),
        );
      });
    }
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
      _mousePosition = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onHover: _onHover,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        clipBehavior: Clip.antiAlias,
        duration: MotionSystem.standard,
        curve: MotionSystem.deceleration,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(0.0, _isHovered ? -6.0 : 0.0)
          ..rotateX(_isHovered ? -_mousePosition.dy * 0.04 : 0.0)
          ..rotateY(_isHovered ? _mousePosition.dx * 0.04 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // Logbook style is sharper
          boxShadow: _isHovered 
              ? [
                  BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, offset: const Offset(0, 15)),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Stack(
              children: [
                // Abstract blueprint sketch background
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: LogbookPainter(
                        isHovered: _isHovered,
                        seed: widget.milestone.title.hashCode,
                      ),
                    ),
                  ),
                ),

                // Core logbook content
                AnimatedContainer(
                  duration: MotionSystem.standard,
                  curve: MotionSystem.deceleration,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _isHovered ? const Color(0x1A0A0F1F) : const Color(0x0F0A0F1F),
                        const Color(0x050A0F1F),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHovered ? const Color(0x4D4F8CFF) : const Color(0x1AFFFFFF),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logbook Header: Commit Hash & Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.commit, color: Color(0xFF4F8CFF), size: 14),
                              const SizedBox(width: 8),
                              Text(
                                widget.milestone.commitHash,
                                style: GoogleFonts.jetBrainsMono(
                                  textStyle: const TextStyle(
                                    color: Color(0xFF4F8CFF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.milestone.logDate,
                            style: GoogleFonts.jetBrainsMono(
                              textStyle: const TextStyle(
                                color: Color(0x66FFFFFF),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Title
                      Text(
                        widget.milestone.title,
                        style: GoogleFonts.plusJakartaSans(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Story / Narrative
                      Text(
                        widget.milestone.story,
                        style: GoogleFonts.geist(
                          textStyle: const TextStyle(
                            color: Color(0xACFFFFFF),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.65,
                          ),
                        ),
                      ),
                      
                      if (widget.milestone.architectureNotes.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0x0AFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0x0FFFFFFF)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '// ARCHITECTURE NOTES',
                                style: GoogleFonts.jetBrainsMono(
                                  textStyle: const TextStyle(
                                    color: Color(0x66FFFFFF),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.milestone.architectureNotes,
                                style: GoogleFonts.geist(
                                  textStyle: const TextStyle(
                                    color: Color(0x8CFFFFFF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Technical Context
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.milestone.technologies.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0x08FFFFFF),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0x1AFFFFFF),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.jetBrainsMono(
                                textStyle: const TextStyle(
                                  color: Color(0x99FFFFFF),
                                  fontSize: 11,
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

                // Cursor Spotlight Overlay
                CursorLightOverlay(
                  normalizedMousePosition: _mousePosition,
                  isHovered: _isHovered,
                  radius: 180.0,
                  intensity: 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
