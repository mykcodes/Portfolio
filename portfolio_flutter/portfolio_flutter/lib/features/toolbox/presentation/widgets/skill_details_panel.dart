import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/skill_model.dart';

class SkillDetailsPanel extends StatefulWidget {
  final SkillModel skill;

  const SkillDetailsPanel({super.key, required this.skill});

  @override
  State<SkillDetailsPanel> createState() => _SkillDetailsPanelState();
}

class _SkillDetailsPanelState extends State<SkillDetailsPanel> with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didUpdateWidget(covariant SkillDetailsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger scan line when skill changes
    if (oldWidget.skill.name != widget.skill.name) {
      _scanController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: const Color(0x08FFFFFF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0x14FFFFFF),
                  width: 1.0,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  key: ValueKey<String>(widget.skill.name),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Module Metadata Title Node
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.skill.name,
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0x0DFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.skill.yearsOfExperience,
                            style: GoogleFonts.geist(
                              textStyle: const TextStyle(
                                color: Color(0xFF4F8CFF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Detailed Functional Runtime Architecture Paragraph Block
                    _buildSectionHeader('ENGINEERING SPECIFICATION'),
                    const SizedBox(height: 12),
                    Text(
                      widget.skill.fullEngineeringDescription,
                      style: GoogleFonts.geist(
                        textStyle: const TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Targeted Deployment Integration Vector
                    _buildSectionHeader('INTEGRATED ENVIRONMENTS'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: widget.skill.linkedProjects.map((project) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.hub_outlined, size: 14, color: Color(0xFF4F8CFF)),
                            const SizedBox(width: 6),
                            Text(
                              project,
                              style: GoogleFonts.geist(
                                textStyle: const TextStyle(
                                  color: Color(0x99FFFFFF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Current Context Focus Area Node
                    _buildSectionHeader('CURRENT SYSTEM OPTIMIZATION PATH'),
                    const SizedBox(height: 12),
                    Text(
                      widget.skill.currentFocus,
                      style: GoogleFonts.geist(
                        textStyle: const TextStyle(
                          color: Color(0x99FFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Highly Decoupled Module Metadata Meta Tags Loop
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.skill.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0x06FFFFFF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0x0DFFFFFF),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            tag,
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
            ),

            // Scanning line overlay on skill change
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _scanController,
                  builder: (context, _) {
                    if (_scanController.value <= 0 || _scanController.value >= 1.0) {
                      return const SizedBox.shrink();
                    }
                    return CustomPaint(
                      painter: _ScanLinePainter(progress: _scanController.value),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Text(
      label,
      style: GoogleFonts.geist(
        textStyle: const TextStyle(
          color: Color(0x52FFFFFF),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

/// Horizontal scan line that sweeps top to bottom on skill change
class _ScanLinePainter extends CustomPainter {
  final double progress;
  _ScanLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double y = size.height * progress;
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0x004F8CFF),
          const Color(0x334F8CFF),
          const Color(0x004F8CFF),
        ],
      ).createShader(Rect.fromLTWH(0, y - 1, size.width, 2));

    canvas.drawRect(Rect.fromLTWH(0, y - 1, size.width, 2), paint);

    // Soft glow above the scan line
    final Paint glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0x004F8CFF),
          const Color(0x0A4F8CFF),
          const Color(0x004F8CFF),
        ],
      ).createShader(Rect.fromLTWH(0, y - 30, size.width, 60));
    canvas.drawRect(Rect.fromLTWH(0, y - 30, size.width, 60), glowPaint);
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter old) => old.progress != progress;
}