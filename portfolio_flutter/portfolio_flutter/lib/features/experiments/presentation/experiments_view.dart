import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/experiments_layout.dart';
import 'widgets/laboratory_background.dart';

class ExperimentsView extends StatefulWidget {
  const ExperimentsView({super.key});

  @override
  State<ExperimentsView> createState() => _ExperimentsViewState();
}

class _ExperimentsViewState extends State<ExperimentsView> with TickerProviderStateMixin {
  late AnimationController _spotlightController;

  @override
  void initState() {
    super.initState();
    _spotlightController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    // Cinematic atmospheric reveal of the spotlight and typography upon entering view
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _spotlightController.forward();
    });
  }

  @override
  void dispose() {
    _spotlightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.sizeOf(context).width >= 600;

    return Stack(
      children: [
        const LaboratoryBackground(),

        // Dynamic Overhead Fading Spotlight Over Laboratory
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _spotlightController,
            builder: (context, child) {
              return Opacity(
                opacity: _spotlightController.value,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.2,
                      colors: [
                        Color(0x0A4F8CFF),
                        Colors.transparent,
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Core Laboratory Content
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40.0 : 20.0, vertical: isDesktop ? 140.0 : 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cinematic Typography Reveal
                  AnimatedBuilder(
                    animation: _spotlightController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _spotlightController.value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1.0 - _spotlightController.value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT EXPERIMENTS',
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 56 : 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: isDesktop ? 4.0 : 2.0,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Things currently under construction.",
                          style: GoogleFonts.geist(
                            textStyle: const TextStyle(
                              color: Color(0x99FFFFFF),
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),

                  // Mounts the Asymmetric Laboratory Modules
                  // Modules handle their own complex timed assembly sequences
                  const RepaintBoundary(
                    child: ExperimentsLayout(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
