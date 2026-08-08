import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/experience_controller.dart';
import '../../../../core/experience/sound_engine.dart';
import '../../../../content/portfolio_data.dart';

class HeroContent extends StatelessWidget {
  const HeroContent({super.key});

  double _getDynamicTitleSize(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 136.0;
    if (width >= 900) return 118.0;
    if (width >= 600) return 88.0;
    return 48.0; // Reduced for small mobile
  }

  double _getDynamicSubtitleSize(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 46.0;
    if (width >= 600) return 36.0;
    return 24.0;
  }

  double _getDynamicDescSize(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= 600) return 16.0;
    return 14.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ExperienceController.instance.scrollController,
      builder: (context, child) {
        double scrollPixels = 0;
        if (ExperienceController.instance.scrollController.hasClients) {
          scrollPixels = ExperienceController.instance.scrollController.offset;
          if (scrollPixels < 0) scrollPixels = 0;
        }

        final double opacity = (1.0 - (scrollPixels / 800)).clamp(0.0, 1.0);
        final double dy = scrollPixels * 0.4;
        final double scale = (1.0 - (scrollPixels / 3000)).clamp(0.95, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..multiply(Matrix4.translationValues(0.0, dy, 0.0))
              ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0)),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: Stack(
        children: [
          const Positioned.fill(child: _LivingHeroBlueprint()),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    _StaggeredItem(
                      delayMs: 1400,
                      child: _BreathingLetterSpacing(
                        child: Text(
                          HeroData.topLabel,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.chakraPetch(
                            textStyle: const TextStyle(
                              color: Color(0xFF4F8CFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 8.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    
                    _StaggeredItem(
                      delayMs: 1800,
                      child: _BreathingTitle(
                        child: Builder(
                          builder: (context) {
                            return Text(
                              HeroData.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.chakraPetch(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: _getDynamicTitleSize(context),
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -2.5,
                                  height: 0.9,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    
                    _StaggeredItem(
                      delayMs: 2300,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Builder(
                          builder: (context) {
                            return Text(
                              HeroData.subtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.chakraPetch(
                                textStyle: TextStyle(
                                  color: const Color(0xB8FFFFFF),
                                  fontSize: _getDynamicSubtitleSize(context),
                                  fontWeight: FontWeight.w400,
                                  height: 1.15,
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    
                      _StaggeredItem(
                        delayMs: 2700,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 620),
                          child: Builder(
                            builder: (context) {
                              return Text(
                                HeroData.description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.chakraPetch(
                                  textStyle: TextStyle(
                                    color: const Color(0x8CFFFFFF),
                                    fontSize: _getDynamicDescSize(context),
                                    fontWeight: FontWeight.w400,
                                    height: 1.6,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                    
                    _StaggeredItem(
                      delayMs: 3000,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 24,
                        runSpacing: 16,
                        children: [
                          _PrimaryAction(
                            text: HeroData.primaryActionText,
                            onTap: () {
                              SoundEngine.instance.playSuccess();
                              final context = ExperienceController
                                  .instance
                                  .sectionKeys['builds']
                                  ?.currentContext;
                              if (context != null) {
                                Scrollable.ensureVisible(
                                  context,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            },
                          ),
                          _SecondaryAction(
                            text: HeroData.secondaryActionText,
                            onTap: () {
                              SoundEngine.instance.playClick();
                              final context = ExperienceController
                                  .instance
                                  .sectionKeys['journey']
                                  ?.currentContext;
                              if (context != null) {
                                Scrollable.ensureVisible(
                                  context,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class _LivingHeroBlueprint extends StatefulWidget {
  const _LivingHeroBlueprint();

  @override
  State<_LivingHeroBlueprint> createState() => _LivingHeroBlueprintState();
}

class _LivingHeroBlueprintState extends State<_LivingHeroBlueprint>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _HeroBlueprintPainter(time: _controller.value * math.pi * 2),
        );
      },
    );
  }
}

class _HeroBlueprintPainter extends CustomPainter {
  final double time;
  _HeroBlueprintPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    
    
    final double opacityCycle = (math.sin(time * 0.5) + 1.0) * 0.5;

    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(
        0xFF4F8CFF,
      ).withValues(alpha: (0.08 * opacityCycle).clamp(0.0, 1.0));

    final Paint nodePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(
        0xFF4F8CFF,
      ).withValues(alpha: (0.15 * opacityCycle).clamp(0.0, 1.0));

    
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    
    final double scanLineY =
        (time / (math.pi * 2) * size.height * 2) % size.height;

    canvas.drawLine(
      Offset(0, scanLineY),
      Offset(size.width, scanLineY),
      Paint()
        ..color = const Color(0xFF4F8CFF).withValues(alpha: 0.05)
        ..strokeWidth = 0.5,
    );

    
    final List<Offset> points = [
      Offset(centerX - 400, centerY - 200),
      Offset(centerX - 200, centerY - 200),
      Offset(centerX - 200, centerY),
      Offset(centerX - 400, centerY),

      Offset(centerX + 200, centerY + 100),
      Offset(centerX + 400, centerY + 100),
      Offset(centerX + 400, centerY - 100),
      Offset(centerX + 200, centerY - 100),
    ];

    
    for (int i = 0; i < points.length; i += 2) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
      canvas.drawCircle(points[i], 3.0, nodePaint);
      canvas.drawCircle(points[i + 1], 3.0, nodePaint);
    }

    
    final double pulseProgress = (time * 2) % (math.pi * 2);
    final double t = pulseProgress / (math.pi * 2); 

    if (t < 0.5) {
      final double localT = t * 2.0;
      final Offset pulsePos = Offset.lerp(points[0], points[1], localT)!;

      canvas.drawCircle(
        pulsePos,
        4.0,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeroBlueprintPainter old) => old.time != time;
}




class _BreathingTitle extends StatefulWidget {
  final Widget child;
  const _BreathingTitle({required this.child});

  @override
  State<_BreathingTitle> createState() => _BreathingTitleState();
}

class _BreathingTitleState extends State<_BreathingTitle>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        
        final double wave = math.sin(_controller.value * math.pi * 2) * 0.004;
        final double wave2 = math.sin(_controller.value * math.pi * 4) * 0.001;
        final double scale = 1.0 + wave + wave2;

        
        final double gradientStop = (_controller.value * 2.0) - 0.5;

        return Transform.scale(
          scale: scale,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: const [
                  Color(0xFF888888), 
                  Color(0xFFFFFFFF), 
                  Color(0xFF888888), 
                ],
                stops: [
                  (gradientStop - 0.3).clamp(0.0, 1.0),
                  gradientStop.clamp(0.0, 1.0),
                  (gradientStop + 0.3).clamp(0.0, 1.0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}




class _BreathingLetterSpacing extends StatefulWidget {
  final Widget child;
  const _BreathingLetterSpacing({required this.child});

  @override
  State<_BreathingLetterSpacing> createState() =>
      _BreathingLetterSpacingState();
}

class _BreathingLetterSpacingState extends State<_BreathingLetterSpacing>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        
        final double wave = math.sin(_controller.value * math.pi * 2) * 0.008;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(1.0 + wave, 1.0, 1.0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}




class _PrimaryAction extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryAction({required this.text, required this.onTap});

  @override
  State<_PrimaryAction> createState() => _PrimaryActionState();
}

class _PrimaryActionState extends State<_PrimaryAction>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          SoundEngine.instance.playHover();
          setState(() => _isHovered = true);
          _sweepController.forward(from: 0.0);
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _sweepController.reverse();
        },
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutExpo,
          transform:
              Matrix4.translationValues(0.0, _isHovered ? -4.0 : 0.0, 0.0)
                ..multiply(
                  Matrix4.diagonal3Values(
                    _isHovered ? 1.03 : 1.0,
                    _isHovered ? 1.03 : 1.0,
                    1.0,
                  ),
                ),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.15),
                      blurRadius: 24,
                      spreadRadius: -4,
                      offset: const Offset(0, 12),
                    ),
                    
                    BoxShadow(
                      color: const Color(0xFF4F8CFF).withValues(alpha: 0.08),
                      blurRadius: 40,
                      spreadRadius: -8,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              Text(
                widget.text,
                style: GoogleFonts.chakraPetch(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _sweepController,
                  builder: (context, _) {
                    if (_sweepController.value <= 0) {
                      return const SizedBox.shrink();
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CustomPaint(
                        painter: _ButtonSweepPainter(
                          progress: _sweepController.value,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonSweepPainter extends CustomPainter {
  final double progress;
  _ButtonSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          const Color(0xFF4F8CFF).withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final double sweepX = (size.width * 2) * progress - size.width;
    canvas.save();
    canvas.translate(sweepX, 0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ButtonSweepPainter old) =>
      old.progress != progress;
}




class _SecondaryAction extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _SecondaryAction({required this.text, required this.onTap});

  @override
  State<_SecondaryAction> createState() => _SecondaryActionState();
}

class _SecondaryActionState extends State<_SecondaryAction>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _reflectionController;

  @override
  void initState() {
    super.initState();
    _reflectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          SoundEngine.instance.playHover();
          setState(() => _isHovered = true);
          _reflectionController.forward(from: 0.0);
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _reflectionController.reverse();
        },
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutExpo,
          transform:
              Matrix4.translationValues(0.0, _isHovered ? -2.0 : 0.0, 0.0)
                ..multiply(
                  Matrix4.diagonal3Values(
                    _isHovered ? 1.01 : 1.0,
                    _isHovered ? 1.01 : 1.0,
                    1.0,
                  ),
                ),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 18),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0x1AFFFFFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered
                  ? const Color(0x40FFFFFF)
                  : const Color(0x24FFFFFF),
              width: 1.0,
            ),
          ),
          child: Stack(
            children: [
              Text(
                widget.text,
                style: GoogleFonts.chakraPetch(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _reflectionController,
                  builder: (context, _) {
                    if (_reflectionController.value <= 0) {
                      return const SizedBox.shrink();
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CustomPaint(
                        painter: _GlassReflectionPainter(
                          progress: _reflectionController.value,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassReflectionPainter extends CustomPainter {
  final double progress;
  _GlassReflectionPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final double sweepX = (size.width * 2) * progress - size.width;
    canvas.save();
    canvas.translate(sweepX, 0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GlassReflectionPainter old) =>
      old.progress != progress;
}




class _StaggeredItem extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const _StaggeredItem({required this.child, required this.delayMs});

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem> {
  bool _start = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) {
        setState(() => _start = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _start ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, animChild) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 24 * (1.0 - value)),
            child: animChild,
          ),
        );
      },
      child: widget.child,
    );
  }
}
