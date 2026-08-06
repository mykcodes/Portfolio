import 'package:flutter/material.dart';
import 'dart:math' as math;


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

  
  Offset calculateMagneticPull(
    Offset elementCenter, {
    double maxDistance = 150.0,
  }) {
    if (magneticTarget == null) return Offset.zero;

    final double dx = position.dx - elementCenter.dx;
    final double dy = position.dy - elementCenter.dy;

    
    final double distance = (dx * dx + dy * dy);
    if (distance > maxDistance * maxDistance) return Offset.zero;

    final double actualDistance = math.sqrt(distance);

    
    final double intensity = 1.0 - (actualDistance / maxDistance);
    final double smoothedIntensity = intensity * intensity; 

    return Offset(
      dx * magneticStrength * smoothedIntensity,
      dy * magneticStrength * smoothedIntensity,
    );
  }
}
