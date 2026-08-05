import 'package:flutter/material.dart';

enum TransitionStyle { cinematic, verticalEmergence, documentary, workstation, laboratory }

/// Applies highly specific, staggered reveals based on scroll intersection.
class SectionTransitionEngine extends StatelessWidget {
  final Widget child;
  final TransitionStyle style;
  final double visibilityProgress; // 0.0 (hidden) to 1.0 (fully visible)

  const SectionTransitionEngine({
    super.key, 
    required this.child, 
    required this.style,
    required this.visibilityProgress,
  });

  @override
  Widget build(BuildContext context) {
    // Limits animation calculations to the visual mounting phase
    final double curvedProgress = Curves.easeOutQuart.transform(visibilityProgress.clamp(0.0, 1.0));
    
    if (curvedProgress == 1.0) return child; // Bypass transforms entirely when fully mounted
    if (curvedProgress == 0.0) return const SizedBox.shrink(); // Cull offscreen

    switch (style) {
      case TransitionStyle.verticalEmergence:
        return Transform.translate(
          offset: Offset(0, 100 * (1.0 - curvedProgress)),
          child: Opacity(opacity: curvedProgress, child: child),
        );
      case TransitionStyle.laboratory:
        return Transform.scale(
          scale: 0.95 + (0.05 * curvedProgress),
          child: Opacity(opacity: curvedProgress, child: child),
        );
      default:
        return Opacity(opacity: curvedProgress, child: child);
    }
  }
}
