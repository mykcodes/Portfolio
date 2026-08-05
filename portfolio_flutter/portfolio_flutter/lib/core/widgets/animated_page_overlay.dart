import 'package:flutter/material.dart';
import '../controllers/experience_controller.dart';

/// Global atmospheric grading (vignettes, scanlines) responsive to scroll depth.
class AnimatedPageOverlay extends StatelessWidget {
  const AnimatedPageOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: ExperienceController.instance.scrollController,
        builder: (context, _) {
          final progress = ExperienceController.instance.globalScrollProgress;
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.transparent,
                  Color.lerp(Colors.transparent, const Color(0xCC050505), progress)!,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
