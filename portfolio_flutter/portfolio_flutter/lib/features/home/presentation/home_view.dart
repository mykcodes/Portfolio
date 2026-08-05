import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../core/controllers/experience_controller.dart';
import '../../../core/experience/scroll_engine.dart';
import '../../../core/experience/sound_engine.dart';
import '../../boot/presentation/widgets/boot_sequence_overlay.dart';
import 'widgets/constellation_background.dart';
import 'widgets/home_navigation_bar.dart';
import 'widgets/hero_content.dart';
import '../../projects/presentation/projects_view.dart';
import '../../journey/presentation/journey_view.dart';
import '../../toolbox/presentation/toolbox_view.dart';
import '../../experiments/presentation/experiments_view.dart';
import '../../connection/presentation/connection_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    ExperienceController.instance.initialize();
    SoundEngine.instance.initialize();
  }

  Color _getAmbientColor(String section) {
    switch (section) {
      case 'hero': return const Color(0xFF070B19);
      case 'builds': return const Color(0xFF050A14);
      case 'journey': return const Color(0xFF0D0A08);
      case 'toolbox': return const Color(0xFF080C11);
      case 'lab': return const Color(0xFF030514);
      case 'connection': return const Color(0xFF050505);
      default: return const Color(0xFF050505);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ExperienceController.instance,
      builder: (context, child) {
        final section = ExperienceController.instance.activeSection;
        final ambientColor = _getAmbientColor(section);
        
        return Scaffold(
          backgroundColor: Colors.black, // Base is black, animated container provides atmosphere
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              // Ambient Atmosphere Layer
              AnimatedContainer(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.easeInOutSine,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.5,
                    colors: [
                      ambientColor,
                      const Color(0xFF030303),
                    ],
                  ),
                ),
              ),
              const Positioned.fill(
            child: ConstellationBackground(),
          ),
          
          Positioned.fill(
            child: SingleChildScrollView(
              controller: ExperienceController.instance.scrollController,
              physics: const CinematicScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  RepaintBoundary(
                    child: Container(
                      key: ExperienceController.instance.sectionKeys['hero'],
                      height: MediaQuery.sizeOf(context).height,
                      alignment: Alignment.center,
                      child: const HeroContent(),
                    ),
                  ),
                  const SizedBox(height: 120),
                  _ParallaxSection(
                    scrollController: ExperienceController.instance.scrollController,
                    parallaxFactor: 0.1,
                    child: RepaintBoundary(child: Container(key: ExperienceController.instance.sectionKeys['builds'], child: const ProjectsView())),
                  ),
                  const SizedBox(height: 140),
                  _ParallaxSection(
                    scrollController: ExperienceController.instance.scrollController,
                    parallaxFactor: 0.05,
                    child: RepaintBoundary(child: Container(key: ExperienceController.instance.sectionKeys['journey'], child: const JourneyView(scrollProgress: 1.0))),
                  ),
                  const SizedBox(height: 140),
                  _ParallaxSection(
                    scrollController: ExperienceController.instance.scrollController,
                    parallaxFactor: 0.08,
                    child: RepaintBoundary(child: Container(key: ExperienceController.instance.sectionKeys['toolbox'], child: const ToolboxView())),
                  ),
                  const SizedBox(height: 140),
                  _ParallaxSection(
                    scrollController: ExperienceController.instance.scrollController,
                    parallaxFactor: 0.12,
                    child: RepaintBoundary(child: Container(key: ExperienceController.instance.sectionKeys['lab'], child: const ExperimentsView())),
                  ),
                  _ParallaxSection(
                    scrollController: ExperienceController.instance.scrollController,
                    parallaxFactor: 0.0,
                    child: RepaintBoundary(child: Container(key: ExperienceController.instance.sectionKeys['connection'], child: const ConnectionView())),
                  ),
                ],
              ),
            ),
          ),
          
          const Positioned(top: 0, left: 0, right: 0, child: HomeNavigationBar()),
          
          // Re-insert Boot Sequence Overlay logic here if required
          const Positioned.fill(
          child: BootSequenceOverlay(),
          ),
        ],
      ),
    );
  },
  );
}
}

class _ParallaxSection extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final double parallaxFactor;

  const _ParallaxSection({
    required this.child,
    required this.scrollController,
    required this.parallaxFactor,
  });

  @override
  Widget build(BuildContext context) {
    if (parallaxFactor == 0) return child;
    
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        double offset = 0;
        if (scrollController.hasClients) {
          final renderObject = context.findRenderObject();
          if (renderObject is RenderBox) {
            final viewport = RenderAbstractViewport.of(renderObject);
            if (viewport != null) {
              final scrollableState = Scrollable.maybeOf(context);
              if (scrollableState != null) {
                try {
                  final alignment = viewport.getOffsetToReveal(renderObject, 0.5);
                  final offsetFromCenter = alignment.offset - scrollController.offset;
                  // Only apply parallax if it's within viewport (roughly)
                  if (offsetFromCenter.abs() < 2000) {
                     offset = offsetFromCenter * parallaxFactor;
                  }
                } catch (e) {
                  // Fallback if render box hasn't fully laid out
                }
              }
            }
          }
        }
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
    );
  }
}