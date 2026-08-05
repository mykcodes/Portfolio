import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/motion_system.dart';
import '../../../../core/widgets/cursor_light_painter.dart';
import '../../models/milestone_model.dart';

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
          borderRadius: BorderRadius.circular(28),
          boxShadow: _isHovered 
              ? [
                  const BoxShadow(color: Color(0x1A4F8CFF), blurRadius: 50, offset: Offset(0, 20)),
                  const BoxShadow(color: Color(0x0C4F8CFF), blurRadius: 15, offset: Offset(0, 8)),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Stack(
              children: [
                // Core card content
                AnimatedContainer(
                  duration: MotionSystem.standard,
                  curve: MotionSystem.deceleration,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _isHovered ? const Color(0x14FFFFFF) : const Color(0x0AFFFFFF),
                        const Color(0x02FFFFFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: _isHovered ? const Color(0x4DFFFFFF) : const Color(0x14FFFFFF),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Year Header Identity Tag
                      AnimatedDefaultTextStyle(
                        duration: MotionSystem.swift,
                        curve: MotionSystem.deceleration,
                        style: GoogleFonts.geist(
                          textStyle: TextStyle(
                            color: _isHovered ? const Color(0xFF4F8CFF) : const Color(0x994F8CFF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                          ),
                        ),
                        child: Text(widget.milestone.year),
                      ),
                      const SizedBox(height: 12),
                      
                      // Milestone Title text
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
                      const SizedBox(height: 16),
                      
                      // Narrative Copy blocks
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
                      const SizedBox(height: 24),
                      
                      // Technical Context Sub-Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.milestone.technologies.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0x0DFFFFFF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0x0FFFFFFF),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.geist(
                                textStyle: const TextStyle(
                                  color: Color(0x8CFFFFFF),
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

                // Cursor Spotlight Overlay
                CursorLightOverlay(
                  normalizedMousePosition: _mousePosition,
                  isHovered: _isHovered,
                  radius: 150.0,
                  intensity: 0.08,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}