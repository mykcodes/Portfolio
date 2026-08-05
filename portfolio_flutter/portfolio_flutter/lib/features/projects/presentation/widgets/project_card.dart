import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/motion_system.dart';
import '../../models/project_model.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;
  bool _isExpanded = false;
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
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: AnimatedContainer(
        duration: MotionSystem.standard,
        curve: MotionSystem.deceleration,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(0.0, _isHovered ? -8.0 : 0.0)
          ..rotateX(_isHovered ? -_mousePosition.dy * 0.03 : 0.0)
          ..rotateY(_isHovered ? _mousePosition.dx * 0.03 : 0.0)
          ..scale(_isHovered ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: _isHovered 
              ? [
                  const BoxShadow(color: Color(0x1F4F8CFF), blurRadius: 60, offset: Offset(0, 20)),
                  const BoxShadow(color: Color(0x144F8CFF), blurRadius: 20, offset: Offset(0, 10)),
                ]
              : [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10)),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: AnimatedContainer(
              clipBehavior: Clip.antiAlias,
              duration: MotionSystem.standard,
              curve: MotionSystem.deceleration,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _isHovered ? const Color(0x1AFFFFFF) : const Color(0x0CFFFFFF),
                    const Color(0x03FFFFFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: _isHovered 
                      ? const Color(0x4DFFFFFF) 
                      : const Color(0x1AFFFFFF),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visual Display Area
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0x05FFFFFF),
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0x1AFFFFFF),
                            width: 1.0,
                          ),
                        ),
                      ),
                      // Replaced overflow property with standard ClipRRect layout
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        child: AnimatedScale(
                          scale: _isHovered ? 1.05 : 1.0,
                          duration: MotionSystem.cinematicDuration,
                          curve: MotionSystem.cinematic,
                          child: Container(
                            color: const Color(0xFF0F0F11),
                            child: Center(
                              child: Icon(
                                Icons.developer_board_outlined,
                                size: 40,
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Text and Actions Meta Wrapper
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project.title,
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.project.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.geist(
                            textStyle: const TextStyle(
                              color: Color(0x99FFFFFF), 
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Tech Stack Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.project.techStack.map((tech) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
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
                                    color: Color(0xB3FFFFFF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                        
                        // Custom Interactive Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Explore Case Study',
                              style: GoogleFonts.geist(
                                textStyle: TextStyle(
                                  color: _isHovered ? Colors.white : const Color(0x8CFFFFFF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            // Replaced non-existent AnimatedTransform with native standard API
                            AnimatedContainer(
                              duration: MotionSystem.swift,
                              curve: MotionSystem.deceleration,
                              transform: Matrix4.identity()
                                ..translate(_isHovered ? 4.0 : 0.0),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: _isHovered ? const Color(0xFF4F8CFF) : const Color(0x8CFFFFFF),
                              ),
                            ),
                          ],
                        ),
                        
                        AnimatedSize(
                          duration: MotionSystem.standard,
                          curve: MotionSystem.deceleration,
                          alignment: Alignment.topCenter,
                          child: _isExpanded ? _buildExpandedDetails() : const SizedBox(width: double.infinity, height: 0),
                        ),
                      ],
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
  }

  Widget _buildExpandedDetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.white.withOpacity(0.08), height: 1),
          const SizedBox(height: 20),
          Text(
            'ARCHITECTURE',
            style: GoogleFonts.geist(
              textStyle: const TextStyle(
                color: Color(0x59FFFFFF),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0x05FFFFFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0x0AFFFFFF)),
            ),
            child: Text(
              widget.project.architectureNotes,
              style: GoogleFonts.jetBrainsMono(
                textStyle: const TextStyle(
                  color: Color(0xFF4F8CFF),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
