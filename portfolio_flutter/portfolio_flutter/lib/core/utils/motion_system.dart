import 'package:flutter/material.dart';

/// The global source of truth for all animation timing and easing in the portfolio.
/// Ensures every micro-interaction and transition feels like it belongs to the same family.
class MotionSystem {
  MotionSystem._();

  // Unified Easing Curves
  static const Curve cinematic = Curves.easeInOutCubic;
  static const Curve deceleration = Curves.easeOutCubic;
  static const Curve acceleration = Curves.easeInCubic;

  // Standardized Durations
  static const Duration micro = Duration(milliseconds: 200); // Hover states, button lifts
  static const Duration swift = Duration(milliseconds: 350); // Small panel reveals
  static const Duration standard = Duration(milliseconds: 600); // Staggered entry elements
  static const Duration cinematicDuration = Duration(milliseconds: 1200); // Large structural shifts
}
