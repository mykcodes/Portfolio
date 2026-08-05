import 'package:flutter/material.dart';

/// Coordinates independent depth planes.
class ParallaxEngine {
  static Offset getOffset({
    required int layer, 
    required double scrollProgress, 
    required double maxScroll,
    Offset? cursorPosition,
    Size? screenSize,
  }) {
    // Layer 0 (Background): Very slow
    // Layer 4 (Floating): Fastest
    final double scrollSpeedMultiplier = (layer + 1) * 0.15;
    double dx = 0;
    double dy = -(scrollProgress * maxScroll * scrollSpeedMultiplier);

    if (cursorPosition != null && screenSize != null && screenSize.width > 0 && screenSize.height > 0) {
      // Normalize cursor position to -1.0 to 1.0 from center
      final double normX = (cursorPosition.dx / screenSize.width) * 2 - 1;
      final double normY = (cursorPosition.dy / screenSize.height) * 2 - 1;
      
      // Determine specific depth multiplier based on layer
      double cursorShiftMultiplier;
      switch (layer) {
        case 0: cursorShiftMultiplier = screenSize.width * 0.025; break; // Background 5% (split across norm -1 to 1)
        case 1: cursorShiftMultiplier = screenSize.width * 0.04; break;  // Grid 8%
        case 2: cursorShiftMultiplier = screenSize.width * 0.075; break; // Geometry/Particles 15%
        case 3: cursorShiftMultiplier = screenSize.width * 0.10; break;  // Foreground 20%
        default: cursorShiftMultiplier = screenSize.width * 0.15;
      }
      
      // We invert the shift so elements move opposite to cursor to create depth
      dx += -normX * cursorShiftMultiplier;
      dy += -normY * cursorShiftMultiplier;
    }

    return Offset(dx, dy);
  }
}
