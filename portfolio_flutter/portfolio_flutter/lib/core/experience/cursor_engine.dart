import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'motion_engine.dart';

/// Manages interactive physics without replacing the native hardware cursor.
class CursorEngine extends ChangeNotifier {
  Offset position = Offset.zero;
  Offset? magneticTarget;
  double magneticStrength = 0.0;

  void updatePosition(Offset newPosition) {
    position = newPosition;
    notifyListeners();
  }

  void engageMagneticTarget(Offset target, {double strength = 0.15}) {
    magneticTarget = target;
    magneticStrength = strength;
    notifyListeners();
  }

  void releaseMagneticTarget() {
    magneticTarget = null;
    magneticStrength = 0.0;
    notifyListeners();
  }

  /// Calculates the physical translation for magnetic UI elements with proximity attenuation
  Offset calculateMagneticPull(Offset elementCenter, {double maxDistance = 150.0}) {
    if (magneticTarget == null) return Offset.zero;
    
    final double dx = position.dx - elementCenter.dx;
    final double dy = position.dy - elementCenter.dy;
    
    // Using simple distance squared check first for performance
    final double distance = (dx * dx + dy * dy);
    if (distance > maxDistance * maxDistance) return Offset.zero;
    
    final double actualDistance = math.sqrt(distance);
    
    // Closer = stronger pull, further = weaker pull. Smoothed with easeOut.
    final double intensity = 1.0 - (actualDistance / maxDistance);
    final double smoothedIntensity = intensity * intensity; // ease-out effect
    
    return Offset(dx * magneticStrength * smoothedIntensity, dy * magneticStrength * smoothedIntensity);
  }
}
