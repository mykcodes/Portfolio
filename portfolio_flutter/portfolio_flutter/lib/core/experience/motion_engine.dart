import 'package:flutter/material.dart';

/// The singular source of truth for all physics and timing.
class MotionEngine {
  MotionEngine._();

  // Easing Physics
  static const Curve cinematic = Curves.easeInOutCubic;
  static const Curve friction = Curves.easeOutExpo;
  static const Curve magnetic = Curves.easeOutBack;
  static const Curve emergence = Curves.easeOutQuart;

  // Cinematic Durations
  static const Duration micro = Duration(milliseconds: 150); // Button presses, highlights
  static const Duration swift = Duration(milliseconds: 350); // Small panels, magnetic snaps
  static const Duration standard = Duration(milliseconds: 700); // Transitions, layouts
  static const Duration cinematicDuration = Duration(milliseconds: 1400); // Section reveals, scrolling
}
