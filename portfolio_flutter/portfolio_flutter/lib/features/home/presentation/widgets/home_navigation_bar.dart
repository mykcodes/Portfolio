import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/experience_controller.dart';
import '../../../../core/utils/motion_system.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> with TickerProviderStateMixin {
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    ExperienceController.instance.addListener(_onExperienceStateChange);
  }

  void _onExperienceStateChange() {
    if (ExperienceController.instance.systemState == SystemState.waking && !_entryController.isAnimating && !_entryController.isCompleted) {
      _entryController.forward();
    }
  }

  @override
  void dispose() {
    ExperienceController.instance.removeListener(_onExperienceStateChange);
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([ExperienceController.instance, _entryController]),
      builder: (context, child) {
        if (ExperienceController.instance.systemState == SystemState.booting) {
          return const SizedBox.shrink();
        }

        final double scrollProgress = ExperienceController.instance.globalScrollProgress;
        final double entryValue = CurvedAnimation(parent: _entryController, curve: MotionSystem.deceleration).value;

        // Scroll Responsive Style Shifts
        final double blurAmount = 16.0 + (scrollProgress * 8.0);
        final Color bgColor = Color.lerp(const Color(0x05FFFFFF), const Color(0x0A000000), scrollProgress)!;
        final Color borderColor = Color.lerp(const Color(0x14FFFFFF), const Color(0x2AFFFFFF), scrollProgress)!;

        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: entryValue,
              child: Transform.translate(
                offset: Offset(0, -20 * (1 - entryValue)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: borderColor, width: 1.0),
                      ),
                      child: Stack(
                        children: [
                          // Top 1px Engineering Progress Line
                          Positioned(
                            top: 0,
                            left: 0,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final totalWidth = MediaQuery.sizeOf(context).width.clamp(0.0, 900.0);
                                final double lineWidth = totalWidth * scrollProgress;
                                return SizedBox(
                                  height: 4,
                                  width: lineWidth + 6, // Extra space for leading dot
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // The progress line itself
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 100),
                                        height: 1,
                                        width: lineWidth,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4F8CFF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF4F8CFF).withOpacity(0.6),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Leading energy dot at the edge
                                      if (scrollProgress > 0.01)
                                        Positioned(
                                          left: lineWidth - 3,
                                          top: -1.5,
                                          child: Container(
                                            width: 4,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF4F8CFF).withOpacity(0.8),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                                BoxShadow(
                                                  color: Colors.white.withOpacity(0.4),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Main Navigation Content Row
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            child: IntrinsicWidth(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Brand Logo & Typography Unit
                                  _NavBrandIdentity(entryAnimation: _entryController),
                                  const SizedBox(width: 48),

                                  // The Interactive Items
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _NavItem(id: 'hero', label: '// SYSTEM', index: 0, entryAnim: _entryController),
                                      _NavItem(id: 'builds', label: 'BUILDS', index: 1, entryAnim: _entryController),
                                      _NavItem(id: 'journey', label: 'JOURNEY', index: 2, entryAnim: _entryController),
                                      _NavItem(id: 'toolbox', label: 'TOOLBOX', index: 3, entryAnim: _entryController),
                                      _NavItem(id: 'lab', label: 'LABORATORY', index: 4, entryAnim: _entryController),
                                      _NavItem(id: 'connection', label: 'TERMINAL', index: 5, entryAnim: _entryController),
                                    ],
                                  ),
                                ],
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
          ),
        );
      },
    );
  }
}

/// Precise Minimal Brand Logo & Typographic Identity
class _NavBrandIdentity extends StatefulWidget {
  final AnimationController entryAnimation;
  const _NavBrandIdentity({required this.entryAnimation});

  @override
  State<_NavBrandIdentity> createState() => _NavBrandIdentityState();
}

class _NavBrandIdentityState extends State<_NavBrandIdentity> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final double fade = CurvedAnimation(parent: widget.entryAnimation, curve: const Interval(0.2, 0.7, curve: MotionSystem.deceleration)).value;

    return Opacity(
      opacity: fade,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => ExperienceController.instance.scrollToSection('hero'),
          child: Container(
            padding: const EdgeInsets.only(left: 12.0, right: 16.0, top: 8.0, bottom: 8.0),
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Geometric Icon
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
                  duration: MotionSystem.micro,
                  curve: MotionSystem.deceleration,
                  builder: (context, value, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(value * 0.035) 
                        ..scale(1.0 + (value * 0.02)),
                      child: CustomPaint(
                        size: const Size(20, 20),
                        painter: _GeometricBrandPainter(hoverValue: value),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 14),
                // Premium Typographic Mark
                AnimatedDefaultTextStyle(
                  duration: MotionSystem.micro,
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: _isHovered ? Colors.white : const Color(0xE6FFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                    ),
                  ),
                  child: const Text('MYK-CODES'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom minimal geometric engineering logo (Interlocking Angles)
class _GeometricBrandPainter extends CustomPainter {
  final double hoverValue;
  _GeometricBrandPainter({required this.hoverValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
      
    final Paint glowPaint = Paint()
      ..color = const Color(0xFF4F8CFF).withOpacity(hoverValue * 0.8)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0)
      ..style = PaintingStyle.stroke;

    final Path path1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.height * 0.5);

    final Path path2 = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.1, size.height * 0.9);

    if (hoverValue > 0) {
      canvas.drawPath(path1, glowPaint);
      canvas.drawPath(path2, glowPaint);
    }

    canvas.drawPath(path1, linePaint);
    canvas.drawPath(path2, linePaint..color = Color.lerp(Colors.white54, const Color(0xFF4F8CFF), hoverValue)!);
  }

  @override
  bool shouldRepaint(covariant _GeometricBrandPainter oldDelegate) => oldDelegate.hoverValue != hoverValue;
}

/// Navigation Item with Sequential Reveal and Magnetic Hover
class _NavItem extends StatefulWidget {
  final String id;
  final String label;
  final int index;
  final AnimationController entryAnim;

  const _NavItem({
    required this.id,
    required this.label,
    required this.index,
    required this.entryAnim,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;
  Offset _magneticOffset = Offset.zero;

  void _onHover(PointerEvent event) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset center = box.size.center(Offset.zero);
    final Offset local = event.localPosition;
    
    final double dx = (local.dx - center.dx) * 0.15;
    final double dy = (local.dy - center.dy) * 0.15;
    
    setState(() {
      _isHovered = true;
      _magneticOffset = Offset(dx, dy);
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
      _magneticOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = ExperienceController.instance.activeSection == widget.id;
    
    final double start = 0.4 + (widget.index * 0.08);
    final double end = math.min(1.0, start + 0.3);
    final double fade = CurvedAnimation(parent: widget.entryAnim, curve: Interval(start, end, curve: MotionSystem.deceleration)).value;

    return Opacity(
      opacity: fade,
      child: MouseRegion(
        onHover: _onHover,
        onExit: _onExit,
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => ExperienceController.instance.scrollToSection(widget.id),
          child: AnimatedContainer(
            duration: MotionSystem.swift,
            curve: MotionSystem.deceleration,
            transform: Matrix4.identity()..translate(_magneticOffset.dx, _magneticOffset.dy),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            color: Colors.transparent, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: MotionSystem.micro,
                  curve: MotionSystem.deceleration,
                  style: GoogleFonts.geist(
                    textStyle: TextStyle(
                      color: isSelected 
                          ? const Color(0xFF4F8CFF) 
                          : (_isHovered ? Colors.white : const Color(0x73FFFFFF)),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ),
                  child: Text(widget.label),
                ),
                const SizedBox(height: 4),
                // Active section underline glow
                AnimatedContainer(
                  duration: MotionSystem.swift,
                  curve: MotionSystem.deceleration,
                  height: 2,
                  width: isSelected ? 16 : 0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F8CFF),
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4F8CFF).withOpacity(0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
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