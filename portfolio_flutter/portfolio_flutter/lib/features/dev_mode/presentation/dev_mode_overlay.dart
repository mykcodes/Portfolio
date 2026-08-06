import 'package:flutter/material.dart';
import '../../../core/controllers/dev_mode_controller.dart';
import 'widgets/fps_counter.dart';
import 'widgets/metrics_panel.dart';
import 'widgets/section_bounds.dart';




class DevModeOverlay extends StatefulWidget {
  const DevModeOverlay({super.key});

  @override
  State<DevModeOverlay> createState() => _DevModeOverlayState();
}

class _DevModeOverlayState extends State<DevModeOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _panelSlideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _panelSlideAnimation =
        Tween<Offset>(
          begin: const Offset(1.0, 0.0), 
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    DevModeController.instance.addListener(_onDevModeChanged);
  }

  void _onDevModeChanged() {
    if (DevModeController.instance.isActive) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
  }

  @override
  void dispose() {
    DevModeController.instance.removeListener(_onDevModeChanged);
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        if (_slideController.value == 0.0) {
          return const SizedBox.shrink();
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              
              const Positioned.fill(
                child: IgnorePointer(child: SectionBounds()),
              ),

              
              Positioned(
                top: 80,
                right: 16,
                child: SlideTransition(
                  position: _panelSlideAnimation,
                  child: const FpsCounter(),
                ),
              ),

              
              Positioned(
                top: 170,
                right: 16,
                child: SlideTransition(
                  position: _panelSlideAnimation,
                  child: const MetricsPanel(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
