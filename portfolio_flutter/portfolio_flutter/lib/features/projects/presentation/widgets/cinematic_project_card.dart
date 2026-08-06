import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/motion_system.dart';
import '../../../../core/widgets/cursor_light_painter.dart';
import '../../../../content/portfolio_data.dart';
import 'engineering_document_view.dart';

class CinematicProjectCard extends StatefulWidget {
  final ProjectContent project;

  const CinematicProjectCard({super.key, required this.project});

  @override
  State<CinematicProjectCard> createState() => _CinematicProjectCardState();
}

class _CinematicProjectCardState extends State<CinematicProjectCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isExpanded = false;
  Offset _mousePosition = Offset.zero;
  late AnimationController _borderGlowController;
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _borderGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _borderGlowController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

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
    _borderGlowController.reverse();
  }

  void _onEnter(PointerEvent event) {
    setState(() => _isHovered = true);
    _borderGlowController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onHover: _onHover,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() {
          _isPressed = false;
          _isExpanded = !_isExpanded;
        }),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _breathingController,
          builder: (context, child) {
            final double breathe = _breathingController.value;
            return AnimatedContainer(
              clipBehavior: Clip.antiAlias,
              duration: MotionSystem.standard,
              curve: MotionSystem.deceleration,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..multiply(
                  Matrix4.translationValues(
                    0.0,
                    _isHovered ? (_isPressed ? 2.0 : -8.0) : 0.0,
                    0.0,
                  ),
                )
                ..rotateX(_isHovered ? -_mousePosition.dy * 0.02 : 0.0)
                ..rotateY(_isHovered ? _mousePosition.dx * 0.02 : 0.0)
                ..multiply(
                  Matrix4.diagonal3Values(
                    _isPressed ? 0.98 : 1.0,
                    _isPressed ? 0.98 : 1.0,
                    1.0,
                  ),
                ),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _isHovered
                        ? const Color(0x14FFFFFF)
                        : const Color(0x08FFFFFF),
                    const Color(0x02FFFFFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered
                      ? const Color(0x664F8CFF)
                      : const Color(
                          0xFF4F8CFF,
                        ).withValues(alpha: 0.05 + breathe * 0.1),
                  width: 1.0,
                ),
                boxShadow: _isHovered
                    ? [
                        const BoxShadow(
                          color: Color(0x1A4F8CFF),
                          blurRadius: 60,
                          offset: Offset(0, 30),
                        ),
                        const BoxShadow(
                          color: Color(0x0A4F8CFF),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: const Color(
                            0xFF4F8CFF,
                          ).withValues(alpha: breathe * 0.03),
                          blurRadius: 20,
                          spreadRadius: breathe * 5,
                        ),
                      ],
              ),
              child: child,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
              child: Stack(
                children: [
                  
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: MotionSystem.standard,
                      curve: MotionSystem.deceleration,
                      opacity: _isHovered ? 1.0 : 0.0,
                      child: AnimatedBuilder(
                        animation: _borderGlowController,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _EnhancedBlueprintPainter(
                              sweepProgress: _borderGlowController.value,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  
                  CursorLightOverlay(
                    normalizedMousePosition: _mousePosition,
                    isHovered: _isHovered,
                    radius: 180.0,
                    intensity: 0.10,
                  ),

                  
                  if (_isHovered)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _borderGlowController,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _CornerBracketPainter(
                              progress: _borderGlowController.value,
                            ),
                          );
                        },
                      ),
                    ),

                  
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.project.title,
                                    style: GoogleFonts.plusJakartaSans(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.project.shortDescription,
                                    style: GoogleFonts.geist(
                                      textStyle: const TextStyle(
                                        color: Color(0x99FFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              duration: MotionSystem.swift,
                              curve: MotionSystem.deceleration,
                              opacity: _isHovered ? 1.0 : 0.5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0x1A4F8CFF),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: const Color(0x334F8CFF),
                                  ),
                                ),
                                child: Text(
                                  widget.project.role.toUpperCase(),
                                  style: GoogleFonts.jetBrainsMono(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF4F8CFF),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        
                        AnimatedSize(
                          duration: MotionSystem.standard,
                          curve: MotionSystem.deceleration,
                          alignment: Alignment.topCenter,
                          child: _isExpanded
                              ? _buildExpandedDetails()
                              : const SizedBox(
                                  width: double.infinity,
                                  height: 0,
                                ),
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
    );
  }

  Widget _buildExpandedDetails() {
    return EngineeringDocumentView(project: widget.project);
  }
}




class _EnhancedBlueprintPainter extends CustomPainter {
  final double sweepProgress;
  _EnhancedBlueprintPainter({required this.sweepProgress});

  static final Paint _gridPaint = Paint()
    ..color = const Color(0x054F8CFF)
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    const double gridSize = 40.0;

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _gridPaint);
    }
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _gridPaint);
    }

    
    if (sweepProgress > 0 && sweepProgress < 1.0) {
      final double sweepX = size.width * sweepProgress;
      final Paint scanPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0x004F8CFF),
            const Color(0x1A4F8CFF),
            const Color(0x004F8CFF),
          ],
        ).createShader(Rect.fromLTWH(sweepX - 40, 0, 80, size.height));
      canvas.drawRect(
        Rect.fromLTWH(sweepX - 40, 0, 80, size.height),
        scanPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnhancedBlueprintPainter old) =>
      old.sweepProgress != sweepProgress;
}




class _CornerBracketPainter extends CustomPainter {
  final double progress;
  _CornerBracketPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final Paint paint = Paint()
      ..color = const Color(0xFF4F8CFF).withValues(alpha: 0.25 * progress)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final double bracketLen = 16.0;
    final double inset = 12.0 + (8.0 * (1.0 - progress)); 

    
    canvas.drawLine(
      Offset(inset, inset),
      Offset(inset + bracketLen, inset),
      paint,
    );
    canvas.drawLine(
      Offset(inset, inset),
      Offset(inset, inset + bracketLen),
      paint,
    );

    
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(size.width - inset - bracketLen, inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(size.width - inset, inset + bracketLen),
      paint,
    );

    
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset + bracketLen, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset, size.height - inset - bracketLen),
      paint,
    );

    
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset - bracketLen, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset, size.height - inset - bracketLen),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter old) =>
      old.progress != progress;
}
