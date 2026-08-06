import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../../core/controllers/experience_controller.dart';
import '../../../core/controllers/dev_mode_controller.dart';
import '../../../core/controllers/console_controller.dart';
import '../../../core/experience/scroll_engine.dart';
import '../../../core/experience/sound_engine.dart';
import '../../boot/presentation/widgets/boot_sequence_overlay.dart';
import '../../console/presentation/engineering_console.dart';
import '../../dev_mode/presentation/dev_mode_overlay.dart';
import 'widgets/constellation_background.dart';
import 'widgets/home_navigation_bar.dart';
import 'widgets/mobile_glass_drawer.dart';
import 'widgets/hero_content.dart';
import '../../about/presentation/about_view.dart';
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
  final FocusNode _globalKeyFocusNode = FocusNode();
  
  // Konami Code sequence
  final List<LogicalKeyboardKey> _konamiSequence = [
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.keyB,
    LogicalKeyboardKey.keyA,
  ];
  int _konamiIndex = 0;

  @override
  void initState() {
    super.initState();
    ExperienceController.instance.initialize();
    SoundEngine.instance.initialize();
    // Auto-focus for keyboard shortcuts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _globalKeyFocusNode.requestFocus();
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    // Konami Code Tracker
    if (event.logicalKey == _konamiSequence[_konamiIndex]) {
      _konamiIndex++;
      if (_konamiIndex == _konamiSequence.length) {
        _konamiIndex = 0;
        ExperienceController.instance.toggleMatrixMode();
        SoundEngine.instance.playClick(); // Or a custom sound if available
        if (!ConsoleController.instance.isOpen) {
          ConsoleController.instance.open();
        }
        ConsoleController.instance.updateInput('matrix');
        ConsoleController.instance.executeCommand();
      }
    } else {
      _konamiIndex = 0;
    }

    // Ctrl+Shift+D → Toggle Developer Mode
    if (event.logicalKey == LogicalKeyboardKey.keyD &&
        HardwareKeyboard.instance.isControlPressed &&
        HardwareKeyboard.instance.isShiftPressed) {
      DevModeController.instance.toggle();
      return;
    }

    // Backtick (`) → Toggle Console
    if (event.logicalKey == LogicalKeyboardKey.backquote &&
        !HardwareKeyboard.instance.isControlPressed &&
        !HardwareKeyboard.instance.isShiftPressed) {
      ConsoleController.instance.toggle();
      return;
    }

    // Escape → Close console if open
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (ConsoleController.instance.isOpen) {
        ConsoleController.instance.close();
        _globalKeyFocusNode.requestFocus();
        return;
      }
    }
  }

  @override
  void dispose() {
    _globalKeyFocusNode.dispose();
    super.dispose();
  }

  Color _getAmbientColor(String section) {
    switch (section) {
      case 'hero': return const Color(0xFF070B19);
      case 'about': return const Color(0xFF060916);
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
          body: KeyboardListener(
            focusNode: _globalKeyFocusNode,
            onKeyEvent: _handleKeyEvent,
            child: Stack(
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
                    colors: ExperienceController.instance.isMatrixMode 
                      ? [const Color(0xFF003300), Colors.black] 
                      : [ambientColor, const Color(0xFF030303)],
                  ),
                ),
              ),
              const Positioned.fill(
                child: ConstellationBackground(),
              ),
              
              // Matrix Rain Effect Overlay
              if (ExperienceController.instance.isMatrixMode)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.15,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            // Optional: If you had a matrix asset, you'd use it here.
                            // For now, a repeating green scanline effect via CSS-like repeating linear gradient approximation
                            image: NetworkImage('https://media.giphy.com/media/xTiTnwj1LUAw0RAriU/giphy.gif'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                    parallaxFactor: 0.15,
                    child: RepaintBoundary(child: Container(key: ExperienceController.instance.sectionKeys['about'], child: const AboutView())),
                  ),
                  const SizedBox(height: 140),
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

          // Developer Mode Overlay (above content, below boot sequence)
          const Positioned.fill(
            child: IgnorePointer(
              child: DevModeOverlay(),
            ),
          ),

          // Interactive Engineering Console
          const EngineeringConsole(),
          
          // Re-insert Boot Sequence Overlay logic here if required
          const Positioned.fill(
            child: BootSequenceOverlay(),
          ),

          // Mobile Drawer Overlay (highest priority)
          const Positioned.fill(
            child: MobileGlassDrawer(),
          ),
        ],
      ),
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
            final scrollableState = Scrollable.maybeOf(context);
            if (scrollableState != null) {
              try {
                final alignment = viewport.getOffsetToReveal(renderObject, 0.5);
                final offsetFromCenter = alignment.offset - scrollController.offset;
                // Only apply parallax if it's within viewport (roughly)
                if (offsetFromCenter.abs() < 2000) {
                   offset = offsetFromCenter * parallaxFactor;
                }
              } catch (_) {
                // If the element is not fully laid out yet, ignore
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
