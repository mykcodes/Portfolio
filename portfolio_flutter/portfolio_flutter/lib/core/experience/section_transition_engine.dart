import 'package:flutter/material.dart';

enum TransitionStyle {
  cinematic,
  verticalEmergence,
  documentary,
  workstation,
  laboratory,
}


class SectionTransitionEngine extends StatelessWidget {
  final Widget child;
  final TransitionStyle style;
  final double visibilityProgress; 

  const SectionTransitionEngine({
    super.key,
    required this.child,
    required this.style,
    required this.visibilityProgress,
  });

  @override
  Widget build(BuildContext context) {
    
    final double curvedProgress = Curves.easeOutQuart.transform(
      visibilityProgress.clamp(0.0, 1.0),
    );

    if (curvedProgress == 1.0) {
      return child; 
    }
    if (curvedProgress == 0.0) {
      return const SizedBox.shrink(); 
    }

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
