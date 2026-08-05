import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';

/// Implements physical momentum, damped deceleration, and velocity smoothing.
/// Tuned for a premium, weighted feel — like scrolling inside Apple Vision Pro.
class CinematicScrollPhysics extends BouncingScrollPhysics {
  const CinematicScrollPhysics({super.parent});

  @override
  CinematicScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CinematicScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get dragStartDistanceMotionThreshold => 2.0;

  @override
  double get minFlingVelocity => 50.0;

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final tolerance = toleranceFor(position);
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: const SpringDescription(
          mass: 1.2,        // Heavier mass for weighted feel
          stiffness: 90.0,  // Slightly softer spring
          damping: 26.0,    // Higher damping for luxurious deceleration
        ),
        position: position.pixels,
        velocity: velocity * 0.78, // Damped velocity for heavy, cinematic momentum
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }
}

/// Scroll behavior that enables premium physics across all platforms
/// and enables mouse-drag scrolling for web/desktop testing.
class CinematicScrollBehavior extends ScrollBehavior {
  const CinematicScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const CinematicScrollPhysics();
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}