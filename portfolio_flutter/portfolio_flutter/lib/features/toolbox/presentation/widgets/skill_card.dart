import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/motion_system.dart';
import '../../../../core/widgets/cursor_light_painter.dart';
import '../../models/skill_model.dart';

class SkillCard extends StatefulWidget {
  final SkillModel skill;
  final bool isSelected;
  final VoidCallback onHoverEntered;

  const SkillCard({
    super.key,
    required this.skill,
    required this.isSelected,
    required this.onHoverEntered,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> with TickerProviderStateMixin {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;
  late AnimationController _reflectionController;
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _reflectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    _breathingController.dispose();
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

  void _handleHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
      if (!hovering) _mousePosition = Offset.zero;
    });
    if (hovering) {
      widget.onHoverEntered();
      _reflectionController.forward(from: 0.0);
    } else {
      _reflectionController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool activeHighlight = _isHovered || widget.isSelected;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onHover: _updateMousePosition,
      onExit: (_) => _handleHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        clipBehavior: Clip.antiAlias,
        duration: MotionSystem.swift,
        curve: MotionSystem.deceleration,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(0.0, _isHovered ? -8.0 : 0.0)
          ..rotateX(_isHovered ? -_mousePosition.dy * 0.05 : 0.0)
          ..rotateY(_isHovered ? _mousePosition.dx * 0.05 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: activeHighlight 
              ? [
                  const BoxShadow(color: Color(0x1F4F8CFF), blurRadius: 40, offset: Offset(0, 15)),
                  const BoxShadow(color: Color(0x144F8CFF), blurRadius: 10, offset: Offset(0, 5)),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: MotionSystem.swift,
                  curve: MotionSystem.deceleration,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        activeHighlight ? const Color(0x14FFFFFF) : const Color(0x0AFFFFFF),
                        const Color(0x02FFFFFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: activeHighlight ? const Color(0x4DFFFFFF) : const Color(0x12FFFFFF),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Layered Modular Tech Icon Anchor Component — with breathing pulse
                      AnimatedBuilder(
                        animation: _breathingController,
                        builder: (context, child) {
                          final double pulse = _breathingController.value;
                          final double scale = 1.0 + math.sin(pulse * math.pi) * 0.06;
                          
                          return AnimatedRotation(
                            turns: _isHovered ? (3 / 360) : 0,
                            duration: MotionSystem.swift,
                            curve: MotionSystem.deceleration,
                            child: Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0x0DFFFFFF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: activeHighlight ? const Color(0x33FFFFFF) : const Color(0x0DFFFFFF),
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.terminal_rounded,
                                    size: 18,
                                    color: activeHighlight ? const Color(0xFF4F8CFF) : Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Component Module Label
                      Text(
                        widget.skill.name,
                        style: GoogleFonts.plusJakartaSans(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Structural Module Data Description
                      Text(
                        widget.skill.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.geist(
                          textStyle: const TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Cursor Spotlight Overlay
                CursorLightOverlay(
                  normalizedMousePosition: _mousePosition,
                  isHovered: _isHovered,
                  radius: 120.0,
                  intensity: 0.08,
                ),

                // Premium Diagonal Glass Reflection Sweep overlay effect
                AnimatedBuilder(
                  animation: _reflectionController,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: CustomPaint(
                        painter: _ReflectionSweepPainter(
                          progress: _reflectionController.value,
                        ),
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

class _ReflectionSweepPainter extends CustomPainter {
  final double progress;
  _ReflectionSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final double sweepPosition = (size.width * 2) * progress - size.width;
    
    canvas.save();
    canvas.translate(sweepPosition, 0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ReflectionSweepPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}