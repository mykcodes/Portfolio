import 'package:flutter/material.dart';


class ParallaxEngine {
  static Offset getOffset({
    required int layer,
    required double scrollProgress,
    required double maxScroll,
    Offset? cursorPosition,
    Size? screenSize,
  }) {
    
    
    final double scrollSpeedMultiplier = (layer + 1) * 0.15;
    double dx = 0;
    double dy = -(scrollProgress * maxScroll * scrollSpeedMultiplier);

    if (cursorPosition != null &&
        screenSize != null &&
        screenSize.width > 0 &&
        screenSize.height > 0) {
      
      final double normX = (cursorPosition.dx / screenSize.width) * 2 - 1;
      final double normY = (cursorPosition.dy / screenSize.height) * 2 - 1;

      
      double cursorShiftMultiplier;
      switch (layer) {
        case 0:
          cursorShiftMultiplier = screenSize.width * 0.025;
          break; 
        case 1:
          cursorShiftMultiplier = screenSize.width * 0.04;
          break; 
        case 2:
          cursorShiftMultiplier = screenSize.width * 0.075;
          break; 
        case 3:
          cursorShiftMultiplier = screenSize.width * 0.10;
          break; 
        default:
          cursorShiftMultiplier = screenSize.width * 0.15;
      }

      
      dx += -normX * cursorShiftMultiplier;
      dy += -normY * cursorShiftMultiplier;
    }

    return Offset(dx, dy);
  }
}
